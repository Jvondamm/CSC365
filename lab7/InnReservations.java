
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import java.util.Map;
import java.util.Scanner;
import java.util.LinkedHashMap;
import java.time.LocalDate;
import java.util.List;
import java.util.ArrayList;


public class InnReservations {
    private final String URL =

    public static void main(String[] args) {
        try {
            InnReservations data = new InnReservations();
        } catch (SQLException e) {
            System.err.println("SQLException: " + e.getMessage());
        }
    }

    private void setup() throws SQLException {
        try (Connection conn = DriverManager.getConnection(System.getenv("HP_JDBC_URL"),
							   System.getenv("HP_JDBC_USER"),
							   System.getenv("HP_JDBC_PW"))) {
                                // create inn tables
                               }
    }
}