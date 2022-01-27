import sys
import csv

def main():
    if len(sys.argv) > 1:
        with open(sys.argv[1]) as f:
            header = f.readline().strip().split(",")
            csv_data = csv.reader(f, delimiter=',', quotechar='"')
            query = "INSERT INTO molecule (%s, %s, %s, %s, %s, %s) VALUES " % tuple(header)
            for row in csv_data:
                tup = str(tuple([x.strip() for x in row]))
                if tup != '()':
                    query += '\n' + tup.strip() + ','
            print(query[:-1] + ';')
    else:
        print("no input file found")
        exit()

if __name__ == "__main__":
  main()

  