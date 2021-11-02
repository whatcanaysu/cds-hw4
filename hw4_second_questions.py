############################################
#
# Now, imagine you are given data from a website that
# has people's CVs. The data comes
# as a list of dictionaries and each
# dictionary looks like this:
#
# { 'user': 'george', 'jobs': ['bar', 'baz', 'qux']}
# e.g. [{'user': 'john', 'jobs': ['analyst', 'engineer']},
#       {'user': 'jane', 'jobs': ['finance', 'software']}]
# we will refer to this as a "CV".
#

example = [{'user': 'john', 'jobs': ['analyst', 'engineer']},
           {'user': 'jane', 'jobs': ['finance', 'software']},
           {'user': 'don', 'jobs': ['analyst','economist']}]

#
# 4)
# Create a function called "has_experience_as"
# that has two parameters:
# 1. A list of CV's.
# 2. A string (job_title)
#
# The function should return a list of strings
# representing the usernames of every user that
# has worked as job_title.

def has_experience_as(lcvs, job):
    answ = []
    for x in lcvs:
        if job in x['jobs']:
            answ.append(x['user'])
    return answ

has_experience_as(example, 'analyst')

#
# 5)
# Create a function called "job_counts"
# that has one parameter: list of CV's
# and returns a dictionary where the
# keys are the job titles and the values
# are the number of users that have done
# that job.

def job_counts(lcvs):
    jobs = []
    for x in lcvs:
        jobs.extend(x['jobs'])
    jobs = set(jobs)
    answ = {}
    for x in jobs:
        answ[x] = len(has_experience_as(lcvs, x))
    return answ

job_counts(example)

#
# 6)
# Create a function, called "most_popular_job"
# that has one parameter: a list of CV's, and
# returns a tuple (str, int) that represents
# the title of the most popular job and the number
# of times it was held by people on the site.
#
# HINT: You should probably use your "job_counts"
# function!
#
# HINT: You can use the method '.items' on
# dictionaries to iterate over them like a
# list of tuples.

def most_popular_job(lcvs):    
    ymax = 0
    for x,y in job_counts(lcvs).items():
        if y > ymax:
            ymax = y
            xmax = x
    return (xmax,ymax)

most_popular_job(example)