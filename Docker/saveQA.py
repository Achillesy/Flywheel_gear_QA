#!/usr/bin/env python3
# The Shebang tells the computer what to call the file with when it runs.
# For more info:https://bash.cyberciti.biz/guide/Shebang

import json
from pprint import pprint

# import flywheel package
import flywheel
from utils.fly.custom_log import *
from utils.fly.load_manifest_json import *
from utils.fly.make_file_name_safe import *

qa_result_file = '/tmp/qa_result.json'
# outbase = "/flywheel/v0/output"

def write_to_meta(result_file_path):
    """
    read from Matlab result and write to .metadata.json
    """

    # Build metadata
    metadata = {}

    # Session metadata
    # metadata["session"] = {}
    # metadata["session"]["timestamp"] = "2020-06-12T06:15:00+00:00"
    # metadata["session"]["operator"] = "NJS"
    # metadata["session"]["label"] = "14840"
    # metadata["session"]["weight"] = 9.07

    # Subject metada
    # metadata["session"]["subject"] = {}
    # metadata["session"]["subject"]["firstname"] = "CIC_MR2"
    # metadata["session"]["subject"]["lastname"] = "ACR"

    # File classification
    dicom_file = {}
    dicom_file["name"] = "test_images2_qa.zip" # necessary
    # dicom_file["modality"] = "MR"
    # dicom_file["classification"] = {}

    # Acquisition metadata
    metadata["acquisition"] = {}
    # metadata["acquisition"]["timestamp"] = "2020-06-12T06:15:58+00:00"
    # metadata["acquisition"]["instrument"] = "MR"
    # metadata["acquisition"]["label"] = "SAG"

    # File info from dicom header
    dicom_file["info"] = {}
    dicom_file["info"]["qa"] = {}
    dicom_file["info"]["qa"]["A1"] = 20200612

    # Append the dicom_file to the files array
    metadata["acquisition"]["files"] = [dicom_file]

    # Write out the metadata to file (.metadadata.json)
    metafile_outname = "/flywheel/v0/output/.metadata.json"
    with open(metafile_outname, "w") as metafile:
        json.dump(metadata, metafile)

    # Show the metadata
    pprint(metadata)

    return metafile_outname

    # result_file_path = open(result_file_path, 'r')
    # print(result_file_path.read())

def write_to_session(context):
    """
    read from Matlab result and update session.info
    session.update(info={"qa":{"save_file_name":"MR2.json", ...}}})
    """

    # Add manifest.json as the manifest_json attribute
    setattr(context, 'manifest_json', load_manifest_json())
    log = custom_log(context)
    context.log_config() # not configuring the log but logging the config

    # Instantiate custom gear dictionary to hold "gear global" info
    context.gear_dict = {}
    # Keep a list of errors and warning to print all in one place at end of log
    # Any errors will prevent the command from running and will cause exit(1)
    context.gear_dict['errors'] = []  
    context.gear_dict['warnings'] = []

    # Get level of run from destination's parent: subject or session
    fw = context.client
    dest_container = fw.get(context.destination['id'])
    context.gear_dict['run_level'] = dest_container.parent.type
    log.info('Running at the ' + context.gear_dict['run_level'] + ' level.')

    # project_id = dest_container.parents.project
    # context.gear_dict['project_id'] = project_id
    # if project_id:
    #     project = fw.get(project_id)
    #     context.gear_dict['project_label'] = project.label
    #     context.gear_dict['project_label_safe'] = \
    #         make_file_name_safe(project.label, '_')
    # else:
    #     context.gear_dict['project_label'] = 'unknown_project'
    #     context.gear_dict['project_label_safe'] = 'unknown_project'
    #     log.warning('Project label is ' + context.gear_dict['project_label'])

    # subject_id = dest_container.parents.subject
    # context.gear_dict['subject_id'] = subject_id
    # if subject_id:
    #     subject = fw.get(subject_id)
    #     context.gear_dict['subject_code'] = subject.code
    #     context.gear_dict['subject_code_safe'] = \
    #         make_file_name_safe(subject.code, '_')
    # else:
    #     context.gear_dict['subject_code'] = 'unknown_subject'
    #     context.gear_dict['subject_code_safe'] = 'unknown_subject'
    #     log.warning('Subject code is ' + context.gear_dict['subject_code'])

    # session_id = dest_container.parents.session
    # context.gear_dict['session_id'] = session_id
    # if session_id:
    #     session = fw.get(session_id)
    #     context.gear_dict['session_label'] = session.label
    #     context.gear_dict['session_label_safe'] = \
    #         make_file_name_safe(session.label, '_')
    # else:
    #     context.gear_dict['session_label'] = 'unknown_session'
    #     context.gear_dict['session_label_safe'] = 'unknown_session'
    #     log.warning('Session label is ' + context.gear_dict['session_label'])
    
    session_id = dest_container.parents.session

    with open(qa_result_file) as qa_result_data:
        qa_result_json = json.load(qa_result_data)
    session = fw.get(session_id)
    session.update(info={"qa":qa_result_json})


if __name__ == "__main__":

    context = flywheel.GearContext()  # Get the gear context.
    log = write_to_session(context)
