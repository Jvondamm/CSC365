import sys

def student(second, third, table):
    for s in table:
        if s[0] == second:
            if third == "B" or third == "Bus":
                print(s[0] + ", " + s[1] + ", " + s[4])
            else:
                print(s[0] + ", " + s[1] + ", " + s[2] + ", " + 
                s[3] + ", " + s[6] + ", " + s[7])

def teacher(second, third, table):
    if third != None:
        print("Error: Teacher does not take a third argument: ", third)
        return
    for s in table:
        if s[6] == second or s[7] == second:
            print(s[0] + ", " + s[1])

def grade(second, third, table):
    gpa_max = 0
    gpa_min = 6
    for s in table:
        if s[2] == second:
            if third == "H" or third == "High":
                if float(s[5]) > float(gpa_max):
                    gpa_max = s[5]
                    temp_student = s
            elif third == "L" or third == "Low":
                if float(s[5]) < float(gpa_min):
                    gpa_min = s[5]
                    temp_student = s
            else:
                print(s[0] + ", " + s[1])
    if third != None:
        print(temp_student[0] + ", " + temp_student[1] + ", " + temp_student[5] 
        + ", " + temp_student[6] + ", " + temp_student[7])

def average(second, third, table):
    if second == None:
        second = 0
    if third != None:
        print("Error: Average does not take a third argument: ", third)
        return
    sum = 0
    count = 0
    for s in table:
        if s[2] == second:
            sum += float(s[5])
            count += 1
    if count != 0:
        avg = round(sum / count, 2)
    else:
        avg = 0
    print(second + ", " + str(avg))


def bus(second, third, table):
    if third != None:
        print("Error: Bus does not take a third argument: ", third)
        return
    for s in table:
        if second == s[4]:
            print(s[1] + ", " + s[0] + ", " + s[2] + ", " + s[3])

def info(second, table):
    if second != None:
        return
    lst = [0] * 7
    for s in table:
        lst[int(s[2])] += 1
    print(lst)

def prompt(table):
    first = None
    second = None
    third = None
    cmd = input("> ")
    args = cmd.split(" ")
    
    first = args[0]
    if len(args) > 1:
        second = args[1]
    if len(args) > 2:
        third = args[2]
    if len(args) > 3:
        print("Error: Unknown Argument:", cmd)
        return
    if first == "Q" or first == "Quit":
        if second != None:
            print("Error: Quit does not take a tsecond argument: ", third)
        exit()
    elif first == "S" or first == "Student":
        student(second, third, table)
    elif first == "T" or first == "Teacher":
        teacher(second, third, table)
    elif first == "G" or first == "Grade":
        grade(second, third, table)
    elif first == "B" or first == "Bus":
        bus(second, third, table)
    elif first == "A" or first == "Average":
        average(second, third, table)
    elif first == "I" or first == "Info":
        info(second, table)
    else:
        print("Error: Unknown Argument:", cmd)
        return

def main():
    filename = "students.txt"

    table = []
    with open(filename) as f:
        while True:
            line = f.readline()
            if not line:
                break
            table.append(line.strip().split(","))

    while True:
        prompt(table)  

if __name__ == "__main__":
  main()