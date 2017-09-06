# Get eligible trips

# Segments
sb_otaz <- list(seg1 = c(3,7,22,14,1,9,5,19,15:18),
                seg2 = c(3,7,22,14,1,9),
                seg3 =  c(3,7))

sb_dtaz <- list(seg1 = c(20,21,12,8),
                seg2 = c(5,19,13,4,20,21,12,8),
                seg3 = c(5,19,13,4,20,21,12,8))

nb_otaz <- list(seg1 = c(6,12,20,21),
                seg2 = c(6,12,20,21,5,19),
                seg3 = c(6,12,20,21,5,19))

nb_dtaz <- list(seg1 = c(5,19,15:18,10,14,23,11,2),
                seg2 = c(10,14,23,11,2),
                seg3 = c(14,23,11,2))

# Read trip table
od_file <- "M:\\Projects\\Northern Coin ELToDv2.3 2017-0628\\Reporting\\ELTOD Output-CSV via Rscript\\ODTrips_2020.CSV"
csv_out <- "M:\\Projects\\Northern Coin ELToDv2.3 2017-0628\\Reporting\\ELTOD Output-CSV via Rscript\\eligibleTrips_2020.csv"

df_od <- read.csv(od_file)
colnames(df_od) <- c("OD",c(1:34))
df_od <- df_od %>% gather(OD)
colnames(df_od) <- c("From", "To", "Trips")


sb_seg1 <- df_od %>% 
           filter(From %in% sb_otaz$seg1, To %in% sb_dtaz$seg1) %>%
           summarise(seg1 = sum(Trips))

sb_seg2 <- df_od %>% 
           filter(From %in% sb_otaz$seg2, To %in% sb_dtaz$seg2) %>%
           summarise(seg2 = sum(Trips))

sb_seg3 <- df_od %>% 
           filter(From %in% sb_otaz$seg3, To %in% sb_dtaz$seg3) %>%
           summarise(seg3 = sum(Trips))


nb_seg1 <- df_od %>% 
           filter(From %in% nb_otaz$seg1, To %in% nb_dtaz$seg1) %>%
           summarise(seg1 = sum(Trips))

nb_seg2 <- df_od %>% 
           filter(From %in% nb_otaz$seg2, To %in% nb_dtaz$seg2) %>%
           summarise(seg2 = sum(Trips))

nb_seg3 <- df_od %>% 
           filter(From %in% nb_otaz$seg3, To %in% nb_dtaz$seg3) %>%
           summarise(seg3 = sum(Trips))


eligibleTrips <- cbind(sb = c(sb_seg1, sb_seg2, sb_seg3),
                       nb = c(nb_seg1, nb_seg2, nb_seg3))

write.csv(eligibleTrips, csv_out)

