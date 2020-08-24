# import flywheel package
import flywheel

context = flywheel.GearContext()  # Get the gear context.
config = context.config           # from the gear context, get the config settings.

## Load in values from the gear configuration.
my_name = config['my_name']
num_rep = config['num_rep']

# Create client
fw = flywheel.Client('rush.trial.flywheel.io:FPzbtsrNQFRjDCNM8N')

self = fw.get_current_user()
print('I am %s %s' % (self.firstname, self.lastname))

all_projects = fw.projects()

project = fw.projects.find_first('label=QA')

#session = project.sessions.find_first('label=Control1')
# for subject in project.subjects.iter():
#     print('%s: %s' % (subject.id, subject.label))

for session in project.sessions():
    print('%s: %s' % (session.id, session.label))
    for acquisition in session.acquisitions():
        print('    %s: %s' % (acquisition.id, acquisition.label))
