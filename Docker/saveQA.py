#!/usr/bin/env python3
# The Shebang tells the computer what to call the file with when it runs.
# For more info:https://bash.cyberciti.biz/guide/Shebang

import json
from pprint import pprint

qa_result_file = '/tmp/qa_result.txt'
outbase = "/flywheel/v0/output"

def write_to_meta(result_file_path):
    """
    read from Matlab result and write to .metadata.json
    """

    # Build metadata
    metadata = {}

    # Session metadata
    metadata["session"] = {}

    # Subject metada
    metadata["session"]["subject"] = {}

    # File classification
    dicom_file = {}
    dicom_file["name"] = "Achilles Zip"
    dicom_file["modality"] = "MR"
    dicom_file["classification"] = {}

    # Acquisition metadata
    metadata["acquisition"] = {}
    metadata["acquisition"]["timestamp"] = "2020-08-16"
    metadata["acquisition"]["instrument"] = "MRA"
    metadata["acquisition"]["label"] = "SAGG"

    # File info from dicom header
    dicom_file["info"] = {}
    dicom_file["WindowCenter"] = 757

    # Append the dicom_file to the files array
    metadata["acquisition"]["files"] = [dicom_file]

    # Write out the metadata to file (.metadadata.json)
    # metafile_outname = "/flywheel/v0/output/.metadata.json"
    metafile_outname = "/flywheel/v0/output/metadata.json"
    with open(metafile_outname, "w") as metafile:
        json.dump(metadata, metafile)

    # Show the metadata
    pprint(metadata)

    return metafile_outname

    # result_file_path = open(result_file_path, 'r')
    # print(result_file_path.read())

if __name__ == "__main__":
    write_to_meta(qa_result_file)
