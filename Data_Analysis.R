library(dplyr)
library(lubridate)
library(data.table)

# These are the wells that we identified
test_wells <- c('19N01W32E003M', 
                '19N02E13Q001M', 
                '18N02W18D004M', 
                '18N01W02E002M',
                '19N01E35B001M')

test_wells <- subset(master_wells, mergeOn %in% test_wells)

# We'll start with the first one
ts <- filter(master, mergeOn == '19N01E35B001M')
# We can look at a histogram first
hist(ts$date, 'months', xlab = "Date", freq = TRUE, format = "%m-%y")

# Next let's summarize the data into tri-monthly means
mon_ts <- ts %>%
  mutate(dategroup = lubridate::floor_date(date, "3 months")) %>%
  group_by(dategroup) %>%
  summarize(Mean_depth=mean(depth.to.GW..ft.))


# Now let's create a time series graph of these means

mon_ts %>%
  ggplot(aes(x = dategroup, y = Mean_depth)) + 
  geom_line() +
  xlab("Date") +
  ylab("Depth (ft)") +
  ggtitle(well) +
  theme(plot.title = element_text(hjust = 0.5))



# ELM CODE

# generate random input weights, W1
#W1=np.random.normal(size=[N, h]) # np is the numpy library
W1 <- matrix(rnorm(73500), 147, 500) 
# X is a matrix of input training data, size MxN
# M is number of input series (17 in our case)
# N is the number of input time steps
# h is the number of neurons (500 in our case)

# generate bias vector, b
#b=np.random.normal(size=[h])
b <- matrix(rnorm(500))

# generate the A matrix (Eq 6)
#a=np.dot(X,W1)+b 
#theta=np.maximum(a,0,a) # basis function


# compute the output weights, W2
# I=np.identity(N) # generate an identity matrix, NxN
I = diag(5)
