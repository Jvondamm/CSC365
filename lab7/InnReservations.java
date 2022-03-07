import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.time.DayOfWeek;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.time.LocalDate;

public class InnReservations {
    private final String JDBC_URL = "jdbc:h2:~/csc365_lab7";
    private final String JDBC_USER = "";
    private final String JDBC_PASSWORD = "";
    private int RES_CODE = 13000;

    public static void main(String[] args) {
        try {
            InnReservations res = new InnReservations();
            res.initDb();
            res.controller();
        } catch (SQLException e) {
            System.err.println("SQLException: " + e.getMessage());
        }
    }
    private void controller() throws SQLException{
        Scanner in = new Scanner(System.in);
        while(true){
            System.out.println("\n\nInput Selection (Enter Choice Number): \n1: Rooms and Rates\n" +
                    "2: Create Reservation\n3: Cancel reservation\n" +
                    "4: Revenue Summery\n5: Exit");
            String cmd = in.next();
            switch(Integer.parseInt(cmd)) {
                case 1:
                    this.roomsAndRates();
                    break;
                case 2:
                    this.createReservation();
                    break;
                case 3:
                    this.deleteReservation();
                    break;
                case 4:
                    this.revenueSummery();
                    break;
                case 5:
                    return;
                default:
                    System.out.println("Invalid entry, please try again");
            }
        }
    }

    private void roomsAndRates() throws SQLException{
        try (Connection conn = DriverManager.getConnection(JDBC_URL,
                JDBC_USER,
                JDBC_PASSWORD)) {
            String sql = "SELECT * FROM lab7_rooms ORDER BY roomName";
            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(sql)) {
                while (rs.next()) {
                    String RoomId = rs.getString("RoomId");
                    String roomName = rs.getString("roomName");
                    float basePrice = rs.getFloat("basePrice");
                    int beds = rs.getInt("beds");
                    String bedType = rs.getString("bedType");
                    int maxOccupancy = rs.getInt("maxOccupancy");
                    String decor = rs.getString("decor");

                    long millis=System.currentTimeMillis();
                    java.sql.Date today=new java.sql.Date(millis);

                    String sql2 = "SELECT checkIn, checkOut FROM lab7_reservation WHERE RoomId = '" + RoomId + "' ORDER BY checkIn ASC";
                    String datecheck = "/None";
                    boolean occ = false;
                    boolean aft = false;
                    java.sql.Date aftFls = null;

                    try (Statement stmt2 = conn.createStatement();
                         ResultSet rs2 = stmt2.executeQuery(sql2)) {
                        while (rs2.next()) {
                            java.sql.Date checkIn = rs2.getDate("checkIn");
                            java.sql.Date checkOut = rs2.getDate("checkOut");
                            if (checkOut.before(today)) continue;
                            else if(checkOut.after(today) && checkIn.before(today)){
                                occ = true;
                                aftFls = checkOut;
                                continue;
                            }
                            else if(checkIn.after(today) && !occ){
                                aft = true;
                                datecheck = "/Today";
                                break;
                            }
                            else if(checkIn.after(today) && occ && checkIn.after(aftFls)){
                                datecheck = aftFls.toString();
                                break;
                            }
                            else if(checkIn.equals(aftFls)){
                                aftFls = checkOut;
                            }
                        }
                        if(occ && !aft) datecheck = aftFls.toString();
                    }

                    System.out.format("Room Name: %s | RoomId: %s | Beds: %d | BedType: %s | Max Occupancy: %d | Base Price: ($%.2f) | Decor: %s | Next Avaliable: %s \n",
                            roomName, RoomId, beds, bedType, maxOccupancy, basePrice, decor, datecheck);
                }
            }

        }
    }

    private void createReservation() throws SQLException {
        try (Connection conn = DriverManager.getConnection(JDBC_URL,
                JDBC_USER,
                JDBC_PASSWORD)) {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy/MM/dd");
            Scanner in = new Scanner(System.in);
            System.out.println("Please Enter First Name: ");
            String firstName = in.next();
            System.out.println("Please Enter Last Name: ");
            String lastName = in.next();
            System.out.println("Please Enter Desired Room Code: ");
            String roomCode = in.next();
            System.out.println("Please Enter Check In Date (YYYY/MM/DD): ");
            String scheckin = in.next();
            LocalDate ltcheckin = LocalDate.parse(scheckin, formatter);
            java.sql.Date checkIn = new java.sql.Date(java.sql.Date.parse(scheckin));
            System.out.println("Please Enter Check Out Date (YYYY/MM/DD): ");
            String scheckout = in.next();
            LocalDate ltcheckout = LocalDate.parse(scheckout, formatter);
            java.sql.Date checkOut = new java.sql.Date(java.sql.Date.parse(scheckout));
            System.out.println("Please Enter Number of Children Staying ");
            int children = Integer.parseInt(in.next());
            System.out.println("Please Enter Number of Adults Staying ");
            int adults = Integer.parseInt(in.next());

            Set<DayOfWeek> weekend = EnumSet.of(DayOfWeek.SATURDAY, DayOfWeek.SUNDAY);
            long weekDaysBetween = ltcheckin.datesUntil(ltcheckout)
                    .filter(d -> !weekend.contains(d.getDayOfWeek()))
                    .count();
            long days =  ltcheckin.datesUntil(ltcheckout).count();

            String sql = "SELECT checkIn, checkOut FROM lab7_reservation WHERE RoomId = '" + roomCode + "' ORDER BY checkIn ASC";
            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(sql)) {
                while (rs.next()) {
                    java.sql.Date qcheckIn = rs.getDate("checkIn");
                    java.sql.Date qcheckOut = rs.getDate("checkOut");
                    if(checkIn.before(qcheckOut) || checkOut.before(qcheckIn)){
                        System.out.println("Room already occupied during requested stay");
                        return;
                    }
                }
            }
            String roomName = "";
            float basePrice = 0;
            String bedType = "";
            int maxOccupancy = 0;
            sql = "SELECT roomName, maxOccupancy, basePrice, bedType FROM lab7_rooms WHERE RoomId = '"+ roomCode+"'";
            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(sql)) {
                while (rs.next()) {
                    roomName = rs.getString("roomName");
                    basePrice = rs.getFloat("basePrice");
                    bedType = rs.getString("bedType");
                    maxOccupancy = rs.getInt("maxOccupancy");
                }
            }

            double totalCost = ((days - weekDaysBetween) * basePrice * 1.10) + (weekDaysBetween * basePrice);

            if(maxOccupancy < children + adults){
                System.out.println("Max Occupancy exceeded");
                return;
            }
            RES_CODE ++;
            String updateSql = "INSERT INTO lab7_reservation VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            conn.setAutoCommit(false);
            try (PreparedStatement pstmt = conn.prepareStatement(updateSql)) {
                pstmt.setInt(1, RES_CODE);
                pstmt.setString(2, roomCode);
                pstmt.setDate(3, checkIn);
                pstmt.setDate(4, checkOut);
                pstmt.setDouble(5, totalCost/days);
                pstmt.setString(6, firstName);
                pstmt.setString(7, lastName);
                pstmt.setInt(8, adults);
                pstmt.setInt(9, children);
                pstmt.executeUpdate();
                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                System.err.println("SQLException: " + e.getMessage());
                return;
            }

            System.out.println("\n RESERVATION SUCCESSFUL!\n" +
                    "Name: " + firstName + " " + lastName + "\n" +
                    "Room Code: " + roomCode +
                    "\nRoom Name: " + roomName +
                    "\nBed Type: " + bedType +
                    "\nNumber of adults: " + adults +
                    "\nNumber of children: " + children +
                    "\nTotal Cost: " + totalCost +
                    "\nReservation Code: "+ RES_CODE);
        }
    }

    private void deleteReservation() throws SQLException {
        try (Connection conn = DriverManager.getConnection(JDBC_URL,
                JDBC_USER,
                JDBC_PASSWORD)) {
            Scanner in = new Scanner(System.in);
            System.out.println("Please enter reservation code to cancel: ");
            int res = Integer.parseInt(in.next());
            System.out.println("Please confirm you would like to cancel reservation " + res + " (Y/N)");
            String confirm = in.next();
            if (confirm.equals("N")){
                System.out.println("\nAborting Cancellation");
            }

            String updateSql = "DELETE FROM lab7_reservation WHERE code = ?";
            conn.setAutoCommit(false);
            try (PreparedStatement pstmt = conn.prepareStatement(updateSql)) {
                pstmt.setInt(1, res);
                pstmt.executeUpdate();
                conn.commit();
            } catch (SQLException e) {
                conn.rollback();
                System.err.println("SQLException: " + e.getMessage());
            }
            System.out.println("Cancellation Successful");
        }
    }

    private void revenueSummery() throws SQLException{
        try (Connection conn = DriverManager.getConnection(JDBC_URL,
                JDBC_USER,
                JDBC_PASSWORD)) {
            HashMap<String, LinkedList<Long>> rev = new HashMap<>();
            LinkedList<Long> l = new LinkedList<>();
            l.add(0L);
            l.add(0L);
            l.add(0L);
            rev.put("AOB", (LinkedList<Long>) l.clone());
            rev.put("CAS", (LinkedList<Long>) l.clone());
            rev.put("FNA", (LinkedList<Long>) l.clone());
            rev.put("HBB", (LinkedList<Long>) l.clone());
            rev.put("IBD", (LinkedList<Long>) l.clone());
            rev.put("IBS", (LinkedList<Long>) l.clone());
            rev.put("MWC", (LinkedList<Long>) l.clone());
            rev.put("RND", (LinkedList<Long>) l.clone());
            rev.put("RTE", (LinkedList<Long>) l.clone());
            rev.put("SAY", (LinkedList<Long>) l.clone());
            rev.put("TAA", (LinkedList<Long>) l.clone());

            long millis=System.currentTimeMillis();
            java.sql.Date today=new java.sql.Date(millis);
            String sql = "SELECT RoomId, SUM(rate * DATEDIFF('DAY', checkIn, checkOut) ) AS Revenue " +
                    "FROM lab7_reservation " +
                    "WHERE MONTH(checkOut) = " + (today.getMonth() + 1) + " " +
                    "GROUP BY RoomId " +
                    "ORDER BY RoomId";
            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(sql)) {
                while (rs.next()) {
                    rev.get(rs.getString("RoomId")).set(0, Math.round(rs.getDouble("Revenue")));
                }
            }
            sql = "SELECT RoomId, SUM(rate * DATEDIFF('DAY', checkIn, checkOut) ) AS Revenue " +
                    "FROM lab7_reservation " +
                    "WHERE MONTH(checkOut) = " + (today.getMonth() + 2) + " " +
                    "GROUP BY RoomId " +
                    "ORDER BY RoomId";
            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(sql)) {
                while (rs.next()) {
                    rev.get(rs.getString("RoomId")).set(1, Math.round(rs.getDouble("Revenue")));
                }
            }
            sql = "SELECT RoomId, SUM(rate * DATEDIFF('DAY', checkIn, checkOut) ) AS Revenue " +
                    "FROM lab7_reservation " +
                    "WHERE MONTH(checkOut) = " + (today.getMonth() + 3) + " " +
                    "GROUP BY RoomId " +
                    "ORDER BY RoomId";
            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(sql)) {
                while (rs.next()) {
                    rev.get(rs.getString("RoomId")).set(2, Math.round(rs.getDouble("Revenue")));
                }
            }
            StringBuilder output = new StringBuilder();
            output.append("\n Revenue Summery\n");
            output.append("RoomCode | This Month | Next Month | 3rd Month | Total\n");
            long col1 = 0L;
            long col2 = 0L;
            long col3 = 0L;
            long col4 = 0L;

            for(Map.Entry<String,LinkedList<Long>> entry : rev.entrySet()){
                col1 = col1 + entry.getValue().get(0);
                col2 = col2 + entry.getValue().get(1);
                col3 = col3 + entry.getValue().get(2);
                long sum = entry.getValue().get(0) + entry.getValue().get(1) + entry.getValue().get(2);
                col4 = col4 + sum;
                output.append(entry.getKey()).append(" | ").append(entry.getValue().get(0)).append(" | ");
                output.append(entry.getValue().get(1)).append(" | ").append(entry.getValue().get(2)).append(" | ").append(sum).append("\n");
            }
            output.append(" Totals | ").append(col1).append(" | ").append(col2).append(" | ").append(col3).append(" | ").append(col4);
            System.out.println(output.toString());
        }
    }

    private void initDb() throws SQLException {
        try (Connection conn = DriverManager.getConnection(JDBC_URL,
                JDBC_USER,
                JDBC_PASSWORD)) {
            try (Statement stmt = conn.createStatement()) {
                stmt.execute("DROP TABLE IF EXISTS lab7_reservation");
                stmt.execute("DROP TABLE IF EXISTS lab7_rooms");
                stmt.execute("CREATE TABLE lab7_rooms (RoomId varchar(3) PRIMARY KEY, roomName varchar(100)," +
                        " beds INTEGER, bedType varchar(50), maxOccupancy INTEGER, basePrice DECIMAL, decor varchar(100))");
                stmt.execute("CREATE TABLE lab7_reservation (code INTEGER PRIMARY KEY, RoomId varchar(3) REFERENCES lab7_rooms," +
                        " checkIn DATE, checkOut DATE, rate DECIMAL, lastName varchar(50), firstName varchar(100), adults INTEGER, kids INTEGER)");
                stmt.execute("INSERT INTO lab7_rooms VALUES ( 'AOB', 'Abscond or bolster', 2, 'Queen', 4, 175, 'traditional' )");
                stmt.execute("INSERT INTO lab7_rooms VALUES ( 'CAS', 'Convoke and sanguine', 2, 'King', 4, 175, 'traditional' )");
                stmt.execute("INSERT INTO lab7_rooms VALUES ( 'FNA', 'Frugal not apropos', 2, 'King', 4, 250, 'traditional' )");
                stmt.execute("INSERT INTO lab7_rooms VALUES ( 'HBB', 'Harbinger but bequest', 1, 'Queen', 2, 100, 'modern' )");
                stmt.execute("INSERT INTO lab7_rooms VALUES ( 'IBD', 'Immutable before decorum', 2, 'Queen', 4, 150, 'rustic' )");
                stmt.execute("INSERT INTO lab7_rooms VALUES ( 'IBS', 'Interim but salutary', 1, 'King', 2, 150, 'traditional' )");
                stmt.execute("INSERT INTO lab7_rooms VALUES ( 'MWC', 'Mendicant with cryptic', 2, 'Double', 4, 125, 'modern' )");
                stmt.execute("INSERT INTO lab7_rooms VALUES ( 'RND', 'Recluse and defiance', 1, 'King', 2, 150, 'modern' )");
                stmt.execute("INSERT INTO lab7_rooms VALUES ( 'RTE', 'Riddle to exculpate', 2, 'Queen', 4, 175, 'rustic' )");
                stmt.execute("INSERT INTO lab7_rooms VALUES ( 'SAY', 'Stay all year', 1, 'Queen', 3, 100, 'modern' )");
                stmt.execute("INSERT INTO lab7_rooms VALUES ( 'TAA', 'Thrift and accolade', 1, 'Double', 2, 75, 'modern' )");
                stmt.execute("INSERT INTO lab7_reservation VALUES ( 10105, 'HBB', '2010-10-23', '2010-10-25', 100, 'SELBIG', 'CONRAD', 1, 0 )");
                stmt.execute("INSERT INTO lab7_reservation VALUES ( 10990, 'CAS', '2010-09-21', '2010-09-27', 174, 'TRACHSEL', 'DAMIEN', 1, 3 )");
                stmt.execute("INSERT INTO lab7_reservation VALUES ( 11631, 'FNA', '2010-04-10', '2010-04-12', 312.5, 'ESPINO', 'MARCELINA', 2, 1 )");
                stmt.execute("INSERT INTO lab7_reservation VALUES ( 10489, 'AOB', '2021-06-30', '2021-07-02', 218.75, 'CARISTO', 'MARKITA', 2, 1 )");
                stmt.execute("INSERT INTO lab7_reservation VALUES ( 10500, 'HBB', '2021-08-11', '2021-08-12', 90, 'YESSIOS', 'ANNIS', 1, 0 )");
                stmt.execute("INSERT INTO lab7_reservation VALUES ( 11718, 'CAS', '2021-07-01', '2021-07-03', 157.5, 'GLIWSKI', 'DAN', 2, 1 )");
                stmt.execute("INSERT INTO lab7_reservation VALUES ( 10574, 'FNA', '2021-06-01', '2021-06-05', 287.5, 'SWEAZY', 'ROY', 2, 1 )");
                stmt.execute("INSERT INTO lab7_reservation VALUES ( 10984, 'AOB', '2021-12-28', '2022-01-01', 201.25, 'ZULLO', 'WILLY', 2, 1 )");
                stmt.execute("INSERT INTO lab7_reservation VALUES ( 10985, 'RND', '2021-06-01', '2021-06-05', 201.25, 'PETE', 'JOE', 2, 1 )");
                stmt.execute("INSERT INTO lab7_reservation VALUES ( 10986, 'RND', '2021-06-05', '2021-06-07', 201.25, 'JOE', 'PETE', 2, 1 )");
                stmt.execute("INSERT INTO lab7_reservation VALUES ( 10987, 'SAY', '2021-06-05', '2021-08-05', 100, 'SELBIG', 'CONRAD', 1, 0 )");
            }
        }
    }
}
