#!/usr/bin/env python3
# The Shebang tells the computer what to call the file with when it runs.
# For more info:https://bash.cyberciti.biz/guide/Shebang

qa_result_file = '/tmp/qa_result.txt'


def write_to_meta(result_file_path):
    """
    read from Matlab result and write to .metadata.json
    """
    if not outbase:
        outbase = "/flywheel/v0/output"

    # Build metadata
    metadata = {}

    result_file_path = open(result_file_path, 'r')
    print(result_file_path.read())


if __name__ == "__main__":
    write_to_meta(qa_result_file)
