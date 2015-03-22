# datacleaningproject
How the script works? </br>
1. Read all the test and trains sets and combines them respectively using rbind </br>
2. Extract the relevant columns in the data thats contains mean() & std() in the column header using grep and subsetting it from the data </br>
3. Join using activty names and activity label using join fuction in plyr to give the activity names for the entire list </br>
4. Renaming the column header to make it readable </br>
5. Using ddply in dplyr to group by subject & activity, and applying colmean to give the average </br>
</br></br>
Code Book </br>
subject: An individual from the 30 volunteers </br>
activity: Activity which the indvidual engaged in </br>
xMean: Mean value of variable x </br>
xStd: Standard deviation of variable x </br>
