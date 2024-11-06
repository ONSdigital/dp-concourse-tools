import os

if __name__ == '__main__':
    print('Hello, World!')

    # check for required PARAMETERS
    if os.environ.get('INPUT_FILE', "missing") == "missing":
        print("Environment variable 'INPUT_FILE' is missing")
        exit(1)

    input_file_name = os.environ['INPUT_FILE']

    print("Path at terminal when executing this script:")
    print(os.getcwd() + "\n")

    arr = os.listdir(os.getcwd())
    print("Listing of current directory:")
    print(arr)
    print()

    print("This scripts file path, relative to os.getcwd():")
    print(__file__ + "\n")

    print("input_file_name: "+input_file_name)
