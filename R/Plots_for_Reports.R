# Plots for reports
# 
# This script produces standard plots in pdf format for use in reports. 
# The following are some standard plots:
# 1. Time of day distribution: Volume % (GU & EL) by driection (NB, SB) - 
#    3 plots (GU vs EL NB and GU vs EL SB, EL by direction)
# 2. v/c by direction (GU vs EL) - 3 plots (GU vs EL NB and GU vs EL SB, EL by direction)
# 3. Diverted Share (EL%) by direction (1 graph)
# 4. Speed by direction (GU vs EL)
# 5. average toll and traffic (2 y-axes)

# Plot GU vs EL shares by time of day

#===============================================================================
# ggplot2: non-interactive graphics
#===============================================================================

require(ggplot2, scales)

# A function to create plots
getPlots <- function(selected_df) {
  
    selected_df <- selected_df %>% ungroup()
    title <- paste("Year", selected_df$Year, "Segment", selected_df$Seg, sep = " ")
    
    # 1. plot diverted_el_shares 
    diverted_el_shares <- selected_df %>% 
           select(NB = EL_NB_SHARE, SB = EL_SB_SHARE, Hour) %>%
           gather(Direction, Shares, -Hour) %>%
           ggplot(aes(x = Hour, y = Shares, colour = Direction)) +
           geom_line(size = 1)+ geom_point(alpha=.3, size = 5) +
           scale_y_continuous(labels = percent) +
           scale_x_continuous(breaks = c(1, 5, 10, 15, 20, 24)) +
           xlab("Hour") + ylab("Diverted Shares (%)") +
           ggtitle("Diverted Percent (EL Share)")+
           # ggtitle(paste(title,"Diverted Percent (EL Share)", sep = " : "))+
           theme_bw()
    
    # 2. plot vc ratio 
    vc_ratio <- selected_df %>% 
           select(`GUL NB` = GU_NB_VC_RATIO, `GUL SB` = GU_SB_VC_RATIO,
                  `EL NB` = EL_NB_VC_RATIO, `EL SB` = EL_SB_VC_RATIO, 
                   Hour) %>%
           gather(Facility, VC_Ratio, -Hour) %>%
           mutate(Direction = ifelse(Facility %in% c("GUL NB", "EL NB"), "NB", "SB"))%>%
           ggplot(aes(x = Hour, y = VC_Ratio, colour = Facility)) + 
           geom_line(size = 1)+ geom_point(alpha=.3, size = 3) +
           facet_grid(~Direction) +
           scale_x_continuous(breaks = c(1, 5, 10, 15, 20, 24)) +
           xlab("Hour") + ylab("v/c Ratio") +
           ggtitle("Volume to Capacity Ratio")+
           # ggtitle(paste(title,"Volume to Capacity Ratio", sep = " : "))+
           theme_bw()
    
    # 3. plot speeds
    speeds <- selected_df %>% 
           select(`GUL NB` = GU_NB_CSPD, `GUL SB` = GU_SB_CSPD,
                  `EL NB` = EL_NB_CSPD, `EL SB` = EL_SB_CSPD, 
                   Hour) %>%
           gather(Facility, Speed, -Hour) %>%
           mutate(Direction = ifelse(Facility %in% c("GUL NB", "EL NB"), "NB", "SB"))%>%
           ggplot(aes(x = Hour, y = Speed, colour = Facility)) + 
           geom_line(size = 1)+ geom_point(alpha=.3, size = 3) +
           facet_grid(~Direction) +
           scale_x_continuous(breaks = c(1, 5, 10, 15, 20, 24)) +
           scale_y_continuous(limits = c(0,75)) +
           xlab("Hour") + ylab("Speed (MPH)") +
           ggtitle("Congested Speeds (MPH)")+
           # ggtitle(paste(title,"Congested Speeds (MPH)", sep = " : "))+
           theme_bw()
    
    # 4. plot GU and EL shares by time of day
    df_tod <- selected_df %>% 
           mutate(`GUL NB` = GU_NB_VOL / sum(GU_NB_VOL),
                  `GUL SB` = GU_SB_VOL / sum(GU_SB_VOL),
                  `EL NB` = EL_NB_VOL / sum(EL_NB_VOL),
                  `EL SB` = EL_SB_VOL / sum(EL_SB_VOL)) %>% 
           select(`GUL NB`, `EL NB`, `GUL SB`, `EL SB`, Hour) %>%
           gather(Facility, Shares, -Hour) %>%
           mutate(Direction = ifelse(Facility %in% c("GUL NB", "EL NB"), "NB", "SB"))%>%     
           ggplot(aes(x = Hour, y = Shares, colour = Facility)) +
           geom_line(size = 1)+ geom_point(alpha=.3, size = 5) +
           facet_grid(~Direction) +
           scale_y_continuous(labels = percent, limits = c(0, 0.20)) +
           scale_x_continuous(breaks = c(1, 5, 10, 15, 20, 24)) +
           xlab("Hour") + ylab("Hourly Traffic Distribution") +
           ggtitle("GUL and EL Hourly Distribution (%)") +
           # ggtitle(paste(title,"GUL and EL Hourly Distribution (%)", sep = " : "))+
           theme_bw()
    
    # 5. plot EL Toll and Traffic
    df_tr <- selected_df %>% 
           select(EL_NB_VOL , EL_NB_TOLL, EL_SB_VOL , EL_SB_TOLL, Hour) %>%
           mutate(`Revenue NB` = EL_NB_VOL * EL_NB_TOLL / sum(EL_NB_VOL * EL_NB_TOLL),
                  `Revenue SB` = EL_SB_VOL * EL_SB_TOLL / sum(EL_SB_VOL * EL_SB_TOLL)) %>%
           select(`Revenue NB`, `Revenue SB`, EL_NB_TOLL, EL_SB_TOLL, Hour) %>%
           gather(temp, Values, -Hour) %>%
           mutate(Type = ifelse(temp %in% c("Revenue NB", "Revenue SB"), "Revenue", "Toll"),
                  Direction = ifelse(temp %in% c("Revenue NB", "EL_NB_TOLL"), "NB", "SB")) %>%
           select(-temp) %>%
           spread(Type, Values)
      
     # Attempt #1 (bug in secondary axis)
     toll_revenue <- ggplot(df_tr, aes(x = Hour, y = Revenue, colour = Direction)) +
           geom_line(size = 1)+ 
           geom_point(alpha=.3, size = 5) +
           geom_bar(aes(x = Hour, y = Toll, fill = Direction ), stat="identity" ) +
           facet_grid(~Direction) +
           scale_y_continuous(labels = percent, 
                              sec.axis = sec_axis(~ . /max(df_tr$Toll), 
                                        labels = dollar_format(prefix = "$")))  +
           scale_x_continuous(breaks = c(1, 5, 10, 15, 20, 24)) +
           xlab("Hour") + ylab("Hourly Traffic Distribution") +
           ggtitle("GUL and EL Hourly Distribution (%)") +
           theme_bw()
    
     # Attempt #2      
     revenue <- df_tr %>%
           ggplot(aes(x = Hour, y = Revenue, colour = Direction)) +
           geom_line(size = 1)+ 
           geom_point(alpha=.3, size = 5) +
           scale_x_continuous(breaks = c(1, 5, 10, 15, 20, 24)) +
           xlab("Hour") + ylab("Revenue Share (%)") +
           scale_y_continuous(labels = percent, position = "right") +
           ggtitle("Revenue Distribution by Hour (%)")+
           # ggtitle(paste(title,"Revenue Distribution by Hour (%)", sep = " : "))+
           theme_bw() + theme(legend.justification = "top",
                              legend.spacing.y = unit(1, "cm"),
                              legend.margin = margin(20,20,20,20),
                              panel.spacing = unit(2, "cm"),
                              plot.margin = margin(t = 0, l = 40, b = 0, r = 20))
           # theme_minimal()+ theme(legend.position = 'bottom')
     
     toll <- df_tr %>%
           ggplot(aes(x = Hour, y = Toll, colour = Direction)) +
           geom_bar(stat="identity", aes(fill = Direction)) + 
           scale_x_continuous(breaks = c(1, 5, 10, 15, 20, 24)) +
           scale_y_continuous(labels = dollar_format(prefix = "$ ")) +
           xlab("Hour") + ylab("Toll ($)") +
           ggtitle("Average Toll by Hour (Dollars)")+
           # ggtitle(paste(title,"Average Toll by Hour (Dollars)", sep = " : "))+
           # theme_bw()
           theme(axis.text.y = element_text(colour = "red"),
                 axis.title.y = element_text(colour = "red", 
                                             margin = margin(t = 0, l = 0, b = 0, r = 25)),
                 panel.background = element_blank(),
                 panel.grid.major.y = element_line(colour = "pink"),
                 legend.position = 'bottom')

      # merge two plots
      g1 <- ggplotGrob(revenue)
      g2 <- ggplotGrob(toll)

      # overlap the panel of 2nd plot on that of 1st plot
      pp <- c(subset(g1$layout, name == "panel", se = t:r))
      g <- gtable_add_grob(g1, g2$grobs[[which(g2$layout$name == "panel")]], pp$t, 
          pp$l, pp$b, pp$l)
      
      g$grobs[[which(g2$layout$name == "ylab-l")]] = g2$grobs[[which(g2$layout$name == "ylab-l")]]
      g$grobs[[which(g2$layout$name == "axis-l")]] = g2$grobs[[which(g2$layout$name == "axis-l")]]
      
      plots <- ggarrange(vc_ratio, speeds, df_tod, ncol = 1,
                         nrow = 2,  
                         ggarrange(diverted_el_shares, g,ncol = 2,
                         nrow = 1))
      return(plots)
     
 }

################################################################################
# Loop over year and segment
################################################################################

# df <- read.csv(paste0(dir_path,"/master_df.csv"))
selected_df <- df %>% 
               filter(Policy == "newPolicy")

# Get years and segments
nyear <- unique(selected_df$Year)
nsegs <- unique(selected_df$Seg)

# Open pdf writer
pdf(paste(dir_path,pdf_output,sep="/"),width=11, height=8.5)

# Print plots
for(y in nyear){
  for (s in nsegs){
    plots <- selected_df %>% 
             filter(Year == y, Seg == s) %>%
             getPlots() %>%
             sapply(plot)
  } 
}

# Close pdf writer
dev.off()

################################################################################