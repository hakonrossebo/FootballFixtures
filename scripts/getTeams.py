import requests


resp = requests.get('http://api.football-data.org/v1/competitions/426/teams', headers={"X-Response-Control":"minified"})

if resp.status_code != 200:
    # This means something went wrong.
    raise ApiError('GET /teams/ {}'.format(resp.status_code))

print ('test')
from operator import itemgetter
# for todo_item in sorted(resp.json()['teams'], key= itemgetter('shortName') ):
#    print ('{},'.format(todo_item['id']), end="")

# for todo_item in sorted(resp.json()['teams'], key= itemgetter('shortName') ):
#    print ('"{}",'.format(todo_item['shortName']), end="")

for todo_item in sorted(resp.json()['teams'], key= itemgetter('shortName') ):
    print ('{} => "{}",'.format(todo_item['id'],todo_item['shortName']), end="")