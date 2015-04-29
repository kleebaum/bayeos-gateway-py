from time import sleep
from bayeosGatewayClient import BayEOSWriter

"""Creates an example writer."""
path = '/tmp/bayeos-device1/'
writer = BayEOSWriter(path, 100)
    
while True:
    print('adding frame\n')
    writer.save(offset=2, values=[[4,2], [1,3], [2,20]])
    sleep(1)
