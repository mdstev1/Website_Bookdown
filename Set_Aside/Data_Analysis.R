test_ts_yr <- data.frame(c())
for (well in test_wells$mergeOn){
  ts <- filter(master, mergeOn == well)
  yr_ts <- ts %>%
    mutate(date = lubridate::floor_date(date, "1 year"), mergeOn = mergeOn) %>%
    group_by(date, mergeOn) %>%
    summarize(Mean_depth=-1*mean(depth.to.GW..ft.))
  test_ts_yr <- as.data.frame(rbind(test_ts_yr, yr_ts))
  #assign(paste(well, "_3mon_ts", sep = ""), mon_ts)
}

# Now let's create time series graphs of these yearly means
test_ts_yr %>%
  ggplot(aes(x = date, y = Mean_depth)) + 
  geom_line() +
  xlab("Date") +
  ylab("Depth (ft)") +
  ggtitle(well) +
  theme(plot.title = element_text(hjust = 0.5)) +
  facet_wrap(~mergeOn)



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
