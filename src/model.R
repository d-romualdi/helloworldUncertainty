library(rsyncrosim)      # Load SyncroSim R package
myScenario <- scenario()  # Get the SyncroSim scenario that is currently running

# Load RunControl datasheet to be able to set timesteps
runSettings <- datasheet(myScenario, name = "helloworldUncertainty_RunControl",
                         returnInvisible = TRUE)

# Set timesteps - can set to different frequencies if desired
timesteps <- seq(runSettings$MinimumTimestep, runSettings$MaximumTimestep)

# Load scenario's input datasheet from SyncroSim library into R dataframe
myInputDataframe <- datasheet(myScenario,
                              name = "helloworldUncertainty_InputDatasheet")

# Extract model inputs from complete input dataframe
mMean <- myInputDataframe$mMean
mSD <- myInputDataframe$mSD
b <- myInputDataframe$b

# Setup empty R dataframe ready to accept output in SyncroSim datasheet format
myOutputDataframe <- datasheet(myScenario,
                               name = "helloworldUncertainty_OutputDatasheet")

# For loop through iterations
for (iter in runSettings$MinimumIteration:runSettings$MaximumIteration) {
  
  # Extract a slope value from normal distribution
  m <- rnorm(n = 1, mean = mMean, sd = mSD)
  
  # Do calculations
  y <- m * timesteps + b
  
  # Store the relevant outputs in a temporary dataframe
  tempDataframe <- data.frame(Timestep = timesteps, 
                              Iteration = iter,
                              y = y)
  
  # Copy output into this R dataframe
  myOutputDataframe <- addRow(myOutputDataframe, tempDataframe)
}

# Save this R dataframe back to the SyncroSim library's output datasheet
saveDatasheet(myScenario,
              data=myOutputDataframe,
              name="helloworldUncertainty_OutputDatasheet")