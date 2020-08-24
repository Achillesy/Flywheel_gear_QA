# import flywheel package
import flywheel
from utils.fly.load_manifest_json import *

def initialize(context):

    # Add manifest.json as the manifest_json attribute
    setattr(context, 'manifest_json', load_manifest_json())

if __name__ == '__main__':
    context = flywheel.GearContext()  # Get the gear context.
    log = initialize(context)
