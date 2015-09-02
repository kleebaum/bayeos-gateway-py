# reads delay test data from csv file

devices_long = c('Raspberry Pi', 'btrzx3', 'btrzx5', 'ultrabook')
sender_modes_long = c('Writer Only', 'Sender as Process', 'Sender as Thread')
filesystem_modes_long = c('Home Dir', 'RAM')

sender_modes = c('-wo-', '-process-', '-thread-')
devices = c('rasp', 'btrzx3', 'btrzx5', 'ultrabook')
filesystem_modes = c('', '-tmp')

prefix = paste('../tests/', devices[d], filesystem_modes[fm], '/Delay-Test', sender_modes[sm], devices[d], filesystem_modes[fm], '-WS', sep='')
if (eval_max_chunk) {
    plot_name = paste(devices[d], filesystem_modes[fm], sender_modes[sm], 'mc.pdf', sep='')
    xlimits = c(0,1000)
    title_text = 'Max Chunk Variation'
} else { 
    plot_name = paste(devices[d], filesystem_modes[fm], sender_modes[sm], 'ws.pdf', sep='')
    xlimits = c()
    title_text = 'Writer Sleep Time Variation'
}

data = list()
timestamp = list()
runtime = list()
channel = list()
write_delay = list()
delta = list()
len = list()

# for every parameter set
for (i in c(1:i_max)) {
if (eval_max_chunk) {
    sleeptime = as.double(ws[1])
    file_name = paste(prefix, ws[1], '-M', mc[i], '.csv', sep='')
} else {
    sleeptime = as.double(ws[i])
    file_name = paste(prefix, ws[i], '-M', mc[1], '.csv', sep='')
}

data[[i]] = read.csv2(file_name, header=T, skip=1)

# timestamp given by BayEOS Writer [sec since 1970-01-01]
timestamp_sec = as.double(strptime(data[[i]][,1], format='%Y-%m-%d %H:%M:%OS')) 
#timestamp_msec = as.double(format(strptime(data[[i]][,1], format='%Y-%m-%d %H:%M:%OS'), format = '%OS3')) %% 1
timestamp_date = as.double(strptime(data[[i]][,1], format='%Y-%m-%d'))
timestamp[[i]] = timestamp_sec - as.numeric(timestamp_date) + 3600
head(timestamp[[i]])

# runtime of the script [sec]
runtime[[i]] = as.double(as.vector(coredata(data[[i]][,2])))
head(runtime[[i]])

# time written in a channel [sec since 1970-01-01]
channel[[i]] = as.double(as.vector(coredata(data[[i]][,3])))
head(channel[[i]])

## time in between the two time() calls:
#plot(channel[[i]], timestamp[[i]])
#write_delay[[i]] = timestamp[[i]] - channel[[i]]
#plot(write_delay[[i]], ylab='Delay frame value and saving time [s]')
#mean(write_delay[[i]])
#hist(write_delay[[i]])

## time between two frames
## = sleep-time + saving-time
## mean, min, max und Streuung
#len[[i]]=length(runtime[[i]])
max_runtime = 999
if(max(runtime[[i]]) < max_runtime)
    max_runtime = floor(max(runtime[[i]]))
len[[i]] = which(floor(runtime[[i]]) == max_runtime)[1]
delta[[i]]=runtime[[i]][2:len[[i]]]-runtime[[i]][1:len[[i]]-1] - sleeptime
#head(delta[[i]])
#plot(delta[[i]], xlab='time')

#median(delta[[i]])
#mean(delta[[i]]) 
#min(delta[[i]])
#max(delta[[i]])
#sd(delta[[i]])
}