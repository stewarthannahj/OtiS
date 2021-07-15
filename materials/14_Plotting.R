library("magrittr")
library("plyr")
library("lattice")
library("ggplot2")
library("dplyr")
library("readr")
library("rmarkdown")
library("Rmisc")
library("devtools")
library("gghalves")
library("sciplot")
library("gridExtra")
library("ggarrange")

# width and height variables for saved plots
w = 6
h = 4
allData=read.csv("~/Documents/projects/OtiS/figures_HJS/OtiS_phase2_taskData.csv")
allData

# split data by group and time
omniT1data <- subset(allData, group=="omni" & time=="T1",
                  select=age:PROMIS_adults_v2)
omniT2data <- subset(allData, group=="omni" & time=="T2",
                      select=age:PROMIS_adults_v2)

osnT1data <- subset(allData, group=="OSN" & time=="T1",
                     select=age:PROMIS_adults_v2)
osnT2data <- subset(allData, group=="OSN" & time=="T2",
                     select=age:PROMIS_adults_v2)

########################################################################################################
### BKB GRAPH
y_lim_min = 0
y_lim_max = 10

omniT1_bkb = omniT1data$BKB_snr50_v1
omniT2_bkb = omniT2data$BKB_snr50_v1
osnT1_bkb = osnT1data$BKB_snr50_v1
osnT2_bkb = osnT2data$BKB_snr50_v1
n_omni=length(omniT1_bkb)
n_osn=length(osnT1_bkb)
omni <- data.frame(y = c(omniT1_bkb, omniT2_bkb),
                x = rep(c(1,2), each=n_omni),
                id = factor(rep(1:n_omni,2)))
osn <- data.frame(y = c(osnT1_bkb, osnT2_bkb),
                   x = rep(c(1,2), each=n_osn),
                   id = factor(rep(1:n_osn,2)))

# omni 
omni_bkb <- ggplot(data = omni, aes(y = y)) +
   
   geom_point(data = omni %>% filter(x =="1"), aes(x = x), color = '#785EF0', size = 1.5, 
              alpha = .5) +
   geom_point(data = omni %>% filter(x =="2"), aes(x = x), color = '#FE6100', size = 1.5, 
              alpha = .5) +
   geom_line(aes(x = x, group = id), color = 'grey5', alpha = .5) +
   
   geom_half_boxplot(
     data = omni %>% filter(x=="1"), aes(x=x, y = y), position = position_nudge(x = -.25), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#785EF0', alpha = .5) +
   
   geom_half_boxplot(
     data = omni %>% filter(x=="2"), aes(x=x, y = y), position = position_nudge(x = .15), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#FE6100', alpha = .5) #+
  
      # geom_half_violin(
      #   data = omni %>% filter(x=="1"),aes(x = x, y = y), position = position_nudge(x = -.37), 
      #   side = "l", fill = '#785EF0', alpha = .5, trim = FALSE) +
      # 
      # geom_half_violin(
      #   data = omni %>% filter(x=="2"),aes(x = x, y = y), position = position_nudge(x = .3), 
      #   side = "r", fill = "#FE6100", alpha = .5, trim = FALSE) 
   
   # Define additional settings
   omni_bkb <-  omni_bkb + scale_x_continuous(breaks=c(1,2), labels=c("1", "2")) + 
       xlab("Research visit") + ylab("SNR loss") +
      ggtitle('omni') +
      theme_classic() + 
      theme(plot.title = element_text(hjust = 0.5)) +
      scale_y_reverse() +
      coord_cartesian(ylim=c(y_lim_max, y_lim_min))
 

# OSN   
   osn_bkb <- ggplot(data = osn, aes(y = y)) +
      
      geom_point(data = osn %>% filter(x =="1"), aes(x = x), color = '#648FFF', size = 1.5, 
                 alpha = .5) +
      geom_point(data = osn %>% filter(x =="2"), aes(x = x), color = '#DC267F', size = 1.5, 
                 alpha = .5) +
      geom_line(aes(x = x, group = id), color = 'grey5', alpha = .5) +
      
      geom_half_boxplot(
         data = osn %>% filter(x=="1"), aes(x=x, y = y), position = position_nudge(x = -.25), 
         side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
         fill = '#648FFF', alpha = .5) +
      
      geom_half_boxplot(
         data = osn %>% filter(x=="2"), aes(x=x, y = y), position = position_nudge(x = .15), 
         side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
         fill = '#DC267F', alpha = .5) #+

            # geom_half_violin(
            #    data = osn %>% filter(x=="1"),aes(x = x, y = y), position = position_nudge(x = -.37),
            #    side = "l", fill = '#648FFF', alpha = .5, trim = FALSE) +
            # 
            # geom_half_violin(
            #    data = osn %>% filter(x=="2"),aes(x = x, y = y), position = position_nudge(x = .3),
            #    side = "r", fill = "#DC267F", alpha = .5, trim = FALSE)
   
   # Define additional settings
   osn_bkb <-  osn_bkb + scale_x_continuous(breaks=c(1,2), labels=c("1", "2")) + 
      xlab("Research visit") +
      ggtitle('OSN') +
      theme_classic() + 
      theme(plot.title = element_text(hjust = 0.5), axis.text.y = element_blank(), axis.title.y = element_blank()) +
      scale_y_reverse() +
      coord_cartesian(ylim=c(y_lim_max, y_lim_min))   
   
# Save png of BKB graphs 
 png = nullGrob()
 png("bkb.png", width=6, height=3, units="in", res=500)
 multiplot(omni_bkb, osn_bkb, cols = 2)
 dev.off()

 ########################################################################################################
 
 
 
 ########################################################################################################
 ### BROWNING GRAPHS
 y_lim_min = -10
 y_lim_max = 32
 
 # BROWNING condition 1
 omniT1_browning1 = omniT1data$BROWNING_thresh1_dBSNR_v1
 omniT2_browning1 = omniT2data$BROWNING_thresh1_dBSNR_v1
 osnT1_browning1 = osnT1data$BROWNING_thresh1_dBSNR_v1
 osnT2_browning1 = osnT2data$BROWNING_thresh1_dBSNR_v1
 n_omni=length(omniT1_browning1)
 n_osn=length(osnT1_browning1)
 omni <- data.frame(y = c(omniT1_browning1, omniT2_browning1),
                    x = rep(c(1,2), each=n_omni),
                    id = factor(rep(1:n_omni,2)))
 osn <- data.frame(y = c(osnT1_browning1, osnT2_browning1),
                   x = rep(c(1,2), each=n_osn),
                   id = factor(rep(1:n_osn,2)))
 
 # omni 
 omni_browning1 <- ggplot(data = omni, aes(y = y)) +
    
    geom_point(data = omni %>% filter(x =="1"), aes(x = x), color = '#785EF0', size = 1.5, 
               alpha = .5) +
    geom_point(data = omni %>% filter(x =="2"), aes(x = x), color = '#FE6100', size = 1.5, 
               alpha = .5) +
    geom_line(aes(x = x, group = id), color = 'grey5', alpha = .5) +
    
    geom_half_boxplot(
       data = omni %>% filter(x=="1"), aes(x=x, y = y), position = position_nudge(x = -.25), 
       side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
       fill = '#785EF0', alpha = .5) +
    
    geom_half_boxplot(
       data = omni %>% filter(x=="2"), aes(x=x, y = y), position = position_nudge(x = .15), 
       side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
       fill = '#FE6100', alpha = .5) #+
    
    # geom_half_violin(
    #    data = omni %>% filter(x=="1"),aes(x = x, y = y), position = position_nudge(x = -.37), 
    #    side = "l", fill = '#785EF0', alpha = .5, trim = FALSE) +
    # 
    # geom_half_violin(
    #    data = omni %>% filter(x=="2"),aes(x = x, y = y), position = position_nudge(x = .3), 
    #    side = "r", fill = "#FE6100", alpha = .5, trim = FALSE) 
 
 # Define additional settings
 omni_browning1 <-  omni_browning1 + scale_x_continuous(breaks=c(1,2), labels=c("1", "2")) + 
    ylab("Condition 1 \n SNR threshold") +
    ggtitle('omni') +
    theme_classic() + 
    theme(plot.title = element_text(hjust = 0.5), axis.text.x = element_blank(), axis.title.x = element_blank()) +
    scale_y_reverse() +
    coord_cartesian(ylim=c(y_lim_max, y_lim_min))
 
 
 # OSN   
 osn_browning1 <- ggplot(data = osn, aes(y = y)) +
    
    geom_point(data = osn %>% filter(x =="1"), aes(x = x), color = '#648FFF', size = 1.5, 
               alpha = .5) +
    geom_point(data = osn %>% filter(x =="2"), aes(x = x), color = '#DC267F', size = 1.5, 
               alpha = .5) +
    geom_line(aes(x = x, group = id), color = 'grey5', alpha = .5) +
    
    geom_half_boxplot(
       data = osn %>% filter(x=="1"), aes(x=x, y = y), position = position_nudge(x = -.25), 
       side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
       fill = '#648FFF', alpha = .5) +
    
    geom_half_boxplot(
       data = osn %>% filter(x=="2"), aes(x=x, y = y), position = position_nudge(x = .15), 
       side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
       fill = '#DC267F', alpha = .5) #+
    
    # geom_half_violin(
    #    data = osn %>% filter(x=="1"),aes(x = x, y = y), position = position_nudge(x = -.37), 
    #    side = "l", fill = '#648FFF', alpha = .5, trim = FALSE) +
    # 
    # geom_half_violin(
    #    data = osn %>% filter(x=="2"),aes(x = x, y = y), position = position_nudge(x = .3), 
    #    side = "r", fill = "#DC267F", alpha = .5, trim = FALSE) 
 
 # Define additional settings
 osn_browning1 <-  osn_browning1 + scale_x_continuous(breaks=c(1,2), labels=c("1", "2")) + 
    ggtitle('OSN') +
    theme_classic() + 
    theme(plot.title = element_text(hjust = 0.5), axis.text.x = element_blank(), axis.title.x = element_blank(), axis.text.y = element_blank(), axis.title.y = element_blank()) +
    scale_y_reverse() +
    coord_cartesian(ylim=c(y_lim_max, y_lim_min)) 
 
 # BROWNING condition 2
 omniT1_browning2 = omniT1data$BROWNING_thresh2_dBSNR_v1
 omniT2_browning2 = omniT2data$BROWNING_thresh2_dBSNR_v1
 osnT1_browning2 = osnT1data$BROWNING_thresh2_dBSNR_v1
 osnT2_browning2 = osnT2data$BROWNING_thresh2_dBSNR_v1
 n_omni=length(omniT1_browning2)
 n_osn=length(osnT1_browning2)
 omni <- data.frame(y = c(omniT1_browning2, omniT2_browning2),
                    x = rep(c(1,2), each=n_omni),
                    id = factor(rep(1:n_omni,2)))
 osn <- data.frame(y = c(osnT1_browning2, osnT2_browning2),
                   x = rep(c(1,2), each=n_osn),
                   id = factor(rep(1:n_osn,2)))
 
 # omni 
 omni_browning2 <- ggplot(data = omni, aes(y = y)) +
    
    geom_point(data = omni %>% filter(x =="1"), aes(x = x), color = '#785EF0', size = 1.5, 
               alpha = .5) +
    geom_point(data = omni %>% filter(x =="2"), aes(x = x), color = '#FE6100', size = 1.5, 
               alpha = .5) +
    geom_line(aes(x = x, group = id), color = 'grey5', alpha = .5) +
    
    geom_half_boxplot(
       data = omni %>% filter(x=="1"), aes(x=x, y = y), position = position_nudge(x = -.25), 
       side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
       fill = '#785EF0', alpha = .5) +
    
    geom_half_boxplot(
       data = omni %>% filter(x=="2"), aes(x=x, y = y), position = position_nudge(x = .15), 
       side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
       fill = '#FE6100', alpha = .5) #+
    
    # geom_half_violin(
    #    data = omni %>% filter(x=="1"),aes(x = x, y = y), position = position_nudge(x = -.37), 
    #    side = "l", fill = '#785EF0', alpha = .5, trim = FALSE) +
    # 
    # geom_half_violin(
    #    data = omni %>% filter(x=="2"),aes(x = x, y = y), position = position_nudge(x = .3), 
    #    side = "r", fill = "#FE6100", alpha = .5, trim = FALSE) 
 
 # Define additional settings
 omni_browning2 <-  omni_browning2 + scale_x_continuous(breaks=c(1,2), labels=c("1", "2")) + 
    ylab("Condition 2 \n SNR threshold") +
    theme_classic() + 
    theme(plot.title = element_text(hjust = 0.5), axis.text.x = element_blank(), axis.title.x = element_blank()) +
    scale_y_reverse() +
    coord_cartesian(ylim=c(y_lim_max, y_lim_min))
 
 
 # OSN   
 osn_browning2 <- ggplot(data = osn, aes(y = y)) +
    
    geom_point(data = osn %>% filter(x =="1"), aes(x = x), color = '#648FFF', size = 1.5, 
               alpha = .5) +
    geom_point(data = osn %>% filter(x =="2"), aes(x = x), color = '#DC267F', size = 1.5, 
               alpha = .5) +
    geom_line(aes(x = x, group = id), color = 'grey5', alpha = .5) +
    
    geom_half_boxplot(
       data = osn %>% filter(x=="1"), aes(x=x, y = y), position = position_nudge(x = -.25), 
       side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
       fill = '#648FFF', alpha = .5) +
    
    geom_half_boxplot(
       data = osn %>% filter(x=="2"), aes(x=x, y = y), position = position_nudge(x = .15), 
       side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
       fill = '#DC267F', alpha = .5) #+
    
    # geom_half_violin(
    #    data = osn %>% filter(x=="1"),aes(x = x, y = y), position = position_nudge(x = -.37), 
    #    side = "l", fill = '#648FFF', alpha = .5, trim = FALSE) +
    # 
    # geom_half_violin(
    #    data = osn %>% filter(x=="2"),aes(x = x, y = y), position = position_nudge(x = .3), 
    #    side = "r", fill = "#DC267F", alpha = .5, trim = FALSE) 
 
 # Define additional settings
 osn_browning2 <-  osn_browning2 + scale_x_continuous(breaks=c(1,2), labels=c("1", "2")) + 
    theme_classic() + 
    theme(plot.title = element_text(hjust = 0.5), axis.text.x = element_blank(), axis.title.x = element_blank(), axis.text.y = element_blank(), axis.title.y = element_blank()) +
    scale_y_reverse() +
    coord_cartesian(ylim=c(y_lim_max, y_lim_min))
 
 
 # BROWNING condition 3
 omniT1_browning3 = omniT1data$BROWNING_thresh3_dBSNR_v1
 omniT2_browning3 = omniT2data$BROWNING_thresh3_dBSNR_v1
 osnT1_browning3 = osnT1data$BROWNING_thresh3_dBSNR_v1
 osnT2_browning3 = osnT2data$BROWNING_thresh3_dBSNR_v1
 n_omni=length(omniT1_browning3)
 n_osn=length(osnT1_browning3)
 omni <- data.frame(y = c(omniT1_browning3, omniT2_browning3),
                    x = rep(c(1,2), each=n_omni),
                    id = factor(rep(1:n_omni,2)))
 osn <- data.frame(y = c(osnT1_browning3, osnT2_browning3),
                   x = rep(c(1,2), each=n_osn),
                   id = factor(rep(1:n_osn,2)))
 
 # omni 
 omni_browning3 <- ggplot(data = omni, aes(y = y)) +
    
    geom_point(data = omni %>% filter(x =="1"), aes(x = x), color = '#785EF0', size = 1.5, 
               alpha = .5) +
    geom_point(data = omni %>% filter(x =="2"), aes(x = x), color = '#FE6100', size = 1.5, 
               alpha = .5) +
    geom_line(aes(x = x, group = id), color = 'grey5', alpha = .5) +
    
    geom_half_boxplot(
       data = omni %>% filter(x=="1"), aes(x=x, y = y), position = position_nudge(x = -.25), 
       side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
       fill = '#785EF0', alpha = .5) +
    
    geom_half_boxplot(
       data = omni %>% filter(x=="2"), aes(x=x, y = y), position = position_nudge(x = .15), 
       side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
       fill = '#FE6100', alpha = .5) #+
    
    # geom_half_violin(
    #    data = omni %>% filter(x=="1"),aes(x = x, y = y), position = position_nudge(x = -.37), 
    #    side = "l", fill = '#785EF0', alpha = .5, trim = FALSE) +
    # 
    # geom_half_violin(
    #    data = omni %>% filter(x=="2"),aes(x = x, y = y), position = position_nudge(x = .3), 
    #    side = "r", fill = "#FE6100", alpha = .5, trim = FALSE) 
 
 # Define additional settings
 omni_browning3 <-  omni_browning3 + scale_x_continuous(breaks=c(1,2), labels=c("1", "2")) + 
    xlab("Research visit") + ylab("Condition 3 \n SNR threshold") +
    theme_classic() + 
    theme(plot.title = element_text(hjust = 0.5)) +
    scale_y_reverse() +
    coord_cartesian(ylim=c(y_lim_max, y_lim_min))
 
 
 # OSN   
 osn_browning3 <- ggplot(data = osn, aes(y = y)) +
    
    geom_point(data = osn %>% filter(x =="1"), aes(x = x), color = '#648FFF', size = 1.5, 
               alpha = .5) +
    geom_point(data = osn %>% filter(x =="2"), aes(x = x), color = '#DC267F', size = 1.5, 
               alpha = .5) +
    geom_line(aes(x = x, group = id), color = 'grey5', alpha = .5) +
    
    geom_half_boxplot(
       data = osn %>% filter(x=="1"), aes(x=x, y = y), position = position_nudge(x = -.25), 
       side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
       fill = '#648FFF', alpha = .5) +
    
    geom_half_boxplot(
       data = osn %>% filter(x=="2"), aes(x=x, y = y), position = position_nudge(x = .15), 
       side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
       fill = '#DC267F', alpha = .5) #+
    
    # geom_half_violin(
    #    data = osn %>% filter(x=="1"),aes(x = x, y = y), position = position_nudge(x = -.37), 
    #    side = "l", fill = '#648FFF', alpha = .5, trim = FALSE) +
    # 
    # geom_half_violin(
    #    data = osn %>% filter(x=="2"),aes(x = x, y = y), position = position_nudge(x = .3), 
    #    side = "r", fill = "#DC267F", alpha = .5, trim = FALSE) 
 
 # Define additional settings
 osn_browning3 <-  osn_browning3 + scale_x_continuous(breaks=c(1,2), labels=c("1", "2")) + 
    xlab("Research visit") +
    theme_classic() + 
   theme(plot.title = element_text(hjust = 0.5), axis.text.y = element_blank(), axis.title.y = element_blank()) +
    scale_y_reverse() +
    coord_cartesian(ylim=c(y_lim_max, y_lim_min))
 
 
 
 # Save png of BROWNING graphs 
 png = nullGrob()
 png("browning.png", width=6, height=8, units="in", res=500)
 multiplot(omni_browning1, omni_browning2, omni_browning3, osn_browning1, osn_browning2, osn_browning3,  cols = 2)
 dev.off()
 
 ########################################################################################################

 
 
 ########################################################################################################
 ### MOLL GRAPHS
 y_lim_min = 25
 y_lim_max = 100
 
 # MOLL short low
 omniT1_moll_shortlow = omniT1data$MOLL_shortlow_v1
 omniT2_moll_shortlow = omniT2data$MOLL_shortlow_v1
 osnT1_moll_shortlow = osnT1data$MOLL_shortlow_v1
 osnT2_moll_shortlow = osnT2data$MOLL_shortlow_v1
 n_omni=length(omniT1_moll_shortlow)
 n_osn=length(osnT1_moll_shortlow)
 omni <- data.frame(y = c(omniT1_moll_shortlow, omniT2_moll_shortlow),
                    x = rep(c(1,2), each=n_omni),
                    id = factor(rep(1:n_omni,2)))
 osn <- data.frame(y = c(osnT1_moll_shortlow, osnT2_moll_shortlow),
                   x = rep(c(1,2), each=n_osn),
                   id = factor(rep(1:n_osn,2)))
 
 # omni 
 omni_moll_shortlow <- ggplot(data = omni, aes(y = y)) +
    
    geom_point(data = omni %>% filter(x =="1"), aes(x = x), color = '#785EF0', size = 1.5, 
               alpha = .5) +
    geom_point(data = omni %>% filter(x =="2"), aes(x = x), color = '#FE6100', size = 1.5, 
               alpha = .5) +
    geom_line(aes(x = x, group = id), color = 'grey5', alpha = .5) +
    
    geom_half_boxplot(
       data = omni %>% filter(x=="1"), aes(x=x, y = y), position = position_nudge(x = -.25), 
       side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
       fill = '#785EF0', alpha = .5) +
    
    geom_half_boxplot(
       data = omni %>% filter(x=="2"), aes(x=x, y = y), position = position_nudge(x = .15), 
       side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
       fill = '#FE6100', alpha = .5) #+
    
    # geom_half_violin(
    #    data = omni %>% filter(x=="1"),aes(x = x, y = y), position = position_nudge(x = -.37), 
    #    side = "l", fill = '#785EF0', alpha = .5, trim = FALSE) +
    # 
    # geom_half_violin(
    #    data = omni %>% filter(x=="2"),aes(x = x, y = y), position = position_nudge(x = .3), 
    #    side = "r", fill = "#FE6100", alpha = .5, trim = FALSE) 
 
 # Define additional settings
 omni_moll_shortlow <-  omni_moll_shortlow + scale_x_continuous(breaks=c(1,2)) + 
    ylab("Short & low sentences \n Accuracy (%)") + 
    ggtitle('omni') +
    theme_classic() + 
    theme(plot.title = element_text(hjust = 0.5), axis.text.x = element_blank(), axis.title.x = element_blank()) +
    coord_cartesian(ylim=c(y_lim_min, y_lim_max))
 
 
 # OSN   
 osn_moll_shortlow <- ggplot(data = osn, aes(y = y)) +
    
    geom_point(data = osn %>% filter(x =="1"), aes(x = x), color = '#648FFF', size = 1.5, 
               alpha = .5) +
    geom_point(data = osn %>% filter(x =="2"), aes(x = x), color = '#DC267F', size = 1.5, 
               alpha = .5) +
    geom_line(aes(x = x, group = id), color = 'grey5', alpha = .5) +
    
    geom_half_boxplot(
       data = osn %>% filter(x=="1"), aes(x=x, y = y), position = position_nudge(x = -.25), 
       side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
       fill = '#648FFF', alpha = .5) +
    
    geom_half_boxplot(
       data = osn %>% filter(x=="2"), aes(x=x, y = y), position = position_nudge(x = .15), 
       side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
       fill = '#DC267F', alpha = .5) #+
    
    # geom_half_violin(
    #    data = osn %>% filter(x=="1"),aes(x = x, y = y), position = position_nudge(x = -.37), 
    #    side = "l", fill = '#648FFF', alpha = .5, trim = FALSE) +
    # 
    # geom_half_violin(
    #    data = osn %>% filter(x=="2"),aes(x = x, y = y), position = position_nudge(x = .3), 
    #    side = "r", fill = "#DC267F", alpha = .5, trim = FALSE) 
 
 # Define additional settings
 osn_moll_shortlow <-  osn_moll_shortlow + scale_x_continuous(breaks=c(1,2)) + 
    ggtitle('OSN') +
    theme_classic() + 
    theme(plot.title = element_text(hjust = 0.5), axis.text.y = element_blank(), axis.title.y = element_blank(), axis.text.x = element_blank(), axis.title.x = element_blank()) +
    coord_cartesian(ylim=c(y_lim_min, y_lim_max)) 
 
 
 # MOLL short high
 omniT1_moll_shorthigh = omniT1data$MOLL_shorthigh_v1
 omniT2_moll_shorthigh = omniT2data$MOLL_shorthigh_v1
 osnT1_moll_shorthigh = osnT1data$MOLL_shorthigh_v1
 osnT2_moll_shorthigh = osnT2data$MOLL_shorthigh_v1
 n_omni=length(omniT1_moll_shorthigh)
 n_osn=length(osnT1_moll_shorthigh)
 omni <- data.frame(y = c(omniT1_moll_shorthigh, omniT2_moll_shorthigh),
                    x = rep(c(1,2), each=n_omni),
                    id = factor(rep(1:n_omni,2)))
 osn <- data.frame(y = c(osnT1_moll_shorthigh, osnT2_moll_shorthigh),
                   x = rep(c(1,2), each=n_osn),
                   id = factor(rep(1:n_osn,2)))
 
 # omni 
 omni_moll_shorthigh <- ggplot(data = omni, aes(y = y)) +
    
    geom_point(data = omni %>% filter(x =="1"), aes(x = x), color = '#785EF0', size = 1.5, 
               alpha = .5) +
    geom_point(data = omni %>% filter(x =="2"), aes(x = x), color = '#FE6100', size = 1.5, 
               alpha = .5) +
    geom_line(aes(x = x, group = id), color = 'grey5', alpha = .5) +
    
    geom_half_boxplot(
       data = omni %>% filter(x=="1"), aes(x=x, y = y), position = position_nudge(x = -.25), 
       side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
       fill = '#785EF0', alpha = .5) +
    
    geom_half_boxplot(
       data = omni %>% filter(x=="2"), aes(x=x, y = y), position = position_nudge(x = .15), 
       side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
       fill = '#FE6100', alpha = .5) #+
    
    # geom_half_violin(
    #    data = omni %>% filter(x=="1"),aes(x = x, y = y), position = position_nudge(x = -.37), 
    #    side = "l", fill = '#785EF0', alpha = .5, trim = FALSE) +
    # 
    # geom_half_violin(
    #    data = omni %>% filter(x=="2"),aes(x = x, y = y), position = position_nudge(x = .3), 
    #    side = "r", fill = "#FE6100", alpha = .5, trim = FALSE) 
 
 # Define additional settings
 omni_moll_shorthigh <-  omni_moll_shorthigh + scale_x_continuous(breaks=c(1,2)) + 
    ylab("Short & high sentences \n Accuracy (%)") +
    theme_classic() + 
    theme(plot.title = element_text(hjust = 0.5), axis.text.x = element_blank(), axis.title.x = element_blank()) +
    coord_cartesian(ylim=c(y_lim_min, y_lim_max))
 
 
 # OSN   
 osn_moll_shorthigh <- ggplot(data = osn, aes(y = y)) +
    
    geom_point(data = osn %>% filter(x =="1"), aes(x = x), color = '#648FFF', size = 1.5, 
               alpha = .5) +
    geom_point(data = osn %>% filter(x =="2"), aes(x = x), color = '#DC267F', size = 1.5, 
               alpha = .5) +
    geom_line(aes(x = x, group = id), color = 'grey5', alpha = .5) +
    
    geom_half_boxplot(
       data = osn %>% filter(x=="1"), aes(x=x, y = y), position = position_nudge(x = -.25), 
       side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
       fill = '#648FFF', alpha = .5) +
    
    geom_half_boxplot(
       data = osn %>% filter(x=="2"), aes(x=x, y = y), position = position_nudge(x = .15), 
       side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
       fill = '#DC267F', alpha = .5) #+
    
    # geom_half_violin(
    #    data = osn %>% filter(x=="1"),aes(x = x, y = y), position = position_nudge(x = -.37), 
    #    side = "l", fill = '#648FFF', alpha = .5, trim = FALSE) +
    # 
    # geom_half_violin(
    #    data = osn %>% filter(x=="2"),aes(x = x, y = y), position = position_nudge(x = .3), 
    #    side = "r", fill = "#DC267F", alpha = .5, trim = FALSE) 
 
 # Define additional settings
 osn_moll_shorthigh <-  osn_moll_shorthigh + scale_x_continuous(breaks=c(1,2)) + 
    theme_classic() + 
    theme(plot.title = element_text(hjust = 0.5), axis.text.y = element_blank(), axis.title.y = element_blank(), axis.text.x = element_blank(), axis.title.x = element_blank()) +
    coord_cartesian(ylim=c(y_lim_min, y_lim_max)) 
 
 
 # MOLL long low
 omniT1_moll_longlow = omniT1data$MOLL_longlow_v1
 omniT2_moll_longlow = omniT2data$MOLL_longlow_v1
 osnT1_moll_longlow = osnT1data$MOLL_longlow_v1
 osnT2_moll_longlow = osnT2data$MOLL_longlow_v1
 n_omni=length(omniT1_moll_longlow)
 n_osn=length(osnT1_moll_longlow)
 omni <- data.frame(y = c(omniT1_moll_longlow, omniT2_moll_longlow),
                    x = rep(c(1,2), each=n_omni),
                    id = factor(rep(1:n_omni,2)))
 osn <- data.frame(y = c(osnT1_moll_longlow, osnT2_moll_longlow),
                   x = rep(c(1,2), each=n_osn),
                   id = factor(rep(1:n_osn,2)))
 
 # omni 
 omni_moll_longlow <- ggplot(data = omni, aes(y = y)) +
    
    geom_point(data = omni %>% filter(x =="1"), aes(x = x), color = '#785EF0', size = 1.5, 
               alpha = .5) +
    geom_point(data = omni %>% filter(x =="2"), aes(x = x), color = '#FE6100', size = 1.5, 
               alpha = .5) +
    geom_line(aes(x = x, group = id), color = 'grey5', alpha = .5) +
    
    geom_half_boxplot(
       data = omni %>% filter(x=="1"), aes(x=x, y = y), position = position_nudge(x = -.25), 
       side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
       fill = '#785EF0', alpha = .5) +
    
    geom_half_boxplot(
       data = omni %>% filter(x=="2"), aes(x=x, y = y), position = position_nudge(x = .15), 
       side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
       fill = '#FE6100', alpha = .5) #+
    
    # geom_half_violin(
    #    data = omni %>% filter(x=="1"),aes(x = x, y = y), position = position_nudge(x = -.37), 
    #    side = "l", fill = '#785EF0', alpha = .5, trim = FALSE) +
    # 
    # geom_half_violin(
    #    data = omni %>% filter(x=="2"),aes(x = x, y = y), position = position_nudge(x = .3), 
    #    side = "r", fill = "#FE6100", alpha = .5, trim = FALSE) 
 
 # Define additional settings
 omni_moll_longlow <-  omni_moll_longlow + scale_x_continuous(breaks=c(1,2)) + 
    ylab("Long & low sentences \n Accuracy (%)") +
    theme_classic() + 
    theme(plot.title = element_text(hjust = 0.5), axis.text.x = element_blank(), axis.title.x = element_blank()) +
    coord_cartesian(ylim=c(y_lim_min, y_lim_max))
 
 
 # OSN   
 osn_moll_longlow <- ggplot(data = osn, aes(y = y)) +
    
    geom_point(data = osn %>% filter(x =="1"), aes(x = x), color = '#648FFF', size = 1.5, 
               alpha = .5) +
    geom_point(data = osn %>% filter(x =="2"), aes(x = x), color = '#DC267F', size = 1.5, 
               alpha = .5) +
    geom_line(aes(x = x, group = id), color = 'grey5', alpha = .5) +
    
    geom_half_boxplot(
       data = osn %>% filter(x=="1"), aes(x=x, y = y), position = position_nudge(x = -.25), 
       side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
       fill = '#648FFF', alpha = .5) +
    
    geom_half_boxplot(
       data = osn %>% filter(x=="2"), aes(x=x, y = y), position = position_nudge(x = .15), 
       side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
       fill = '#DC267F', alpha = .5) #+
    
    # geom_half_violin(
    #    data = osn %>% filter(x=="1"),aes(x = x, y = y), position = position_nudge(x = -.37), 
    #    side = "l", fill = '#648FFF', alpha = .5, trim = FALSE) +
    # 
    # geom_half_violin(
    #    data = osn %>% filter(x=="2"),aes(x = x, y = y), position = position_nudge(x = .3), 
    #    side = "r", fill = "#DC267F", alpha = .5, trim = FALSE) 
 
 # Define additional settings
 osn_moll_longlow <-  osn_moll_longlow + scale_x_continuous(breaks=c(1,2)) + 
    theme_classic() + 
    theme(plot.title = element_text(hjust = 0.5), axis.text.y = element_blank(), axis.title.y = element_blank(), axis.text.x = element_blank(), axis.title.x = element_blank()) +
    coord_cartesian(ylim=c(y_lim_min, y_lim_max)) 
 
 
 # MOLL long high
 omniT1_moll_longhigh = omniT1data$MOLL_longhigh_v1
 omniT2_moll_longhigh = omniT2data$MOLL_longhigh_v1
 osnT1_moll_longhigh = osnT1data$MOLL_longhigh_v1
 osnT2_moll_longhigh = osnT2data$MOLL_longhigh_v1
 n_omni=length(omniT1_moll_longhigh)
 n_osn=length(osnT1_moll_longhigh)
 omni <- data.frame(y = c(omniT1_moll_longhigh, omniT2_moll_longhigh),
                    x = rep(c(1,2), each=n_omni),
                    id = factor(rep(1:n_omni,2)))
 osn <- data.frame(y = c(osnT1_moll_longhigh, osnT2_moll_longhigh),
                   x = rep(c(1,2), each=n_osn),
                   id = factor(rep(1:n_osn,2)))
 
 # omni 
 omni_moll_longhigh <- ggplot(data = omni, aes(y = y)) +
    
    geom_point(data = omni %>% filter(x =="1"), aes(x = x), color = '#785EF0', size = 1.5, 
               alpha = .5) +
    geom_point(data = omni %>% filter(x =="2"), aes(x = x), color = '#FE6100', size = 1.5, 
               alpha = .5) +
    geom_line(aes(x = x, group = id), color = 'grey5', alpha = .5) +
    
    geom_half_boxplot(
       data = omni %>% filter(x=="1"), aes(x=x, y = y), position = position_nudge(x = -.25), 
       side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
       fill = '#785EF0', alpha = .5) +
    
    geom_half_boxplot(
       data = omni %>% filter(x=="2"), aes(x=x, y = y), position = position_nudge(x = .15), 
       side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
       fill = '#FE6100', alpha = .5) #+
    
    # geom_half_violin(
    #    data = omni %>% filter(x=="1"),aes(x = x, y = y), position = position_nudge(x = -.37), 
    #    side = "l", fill = '#785EF0', alpha = .5, trim = FALSE) +
    # 
    # geom_half_violin(
    #    data = omni %>% filter(x=="2"),aes(x = x, y = y), position = position_nudge(x = .3), 
    #    side = "r", fill = "#FE6100", alpha = .5, trim = FALSE) 
 
 # Define additional settings
 omni_moll_longhigh <-  omni_moll_longhigh + scale_x_continuous(breaks=c(1,2), labels=c("1", "2")) + 
    xlab("Research visit") + ylab("Long & high sentences \n Accuracy (%)") +
    theme_classic() + 
    theme(plot.title = element_text(hjust = 0.5)) +
    coord_cartesian(ylim=c(y_lim_min, y_lim_max))
 
 
 # OSN   
 osn_moll_longhigh <- ggplot(data = osn, aes(y = y)) +
    
    geom_point(data = osn %>% filter(x =="1"), aes(x = x), color = '#648FFF', size = 1.5, 
               alpha = .5) +
    geom_point(data = osn %>% filter(x =="2"), aes(x = x), color = '#DC267F', size = 1.5, 
               alpha = .5) +
    geom_line(aes(x = x, group = id), color = 'grey5', alpha = .5) +
    
    geom_half_boxplot(
       data = osn %>% filter(x=="1"), aes(x=x, y = y), position = position_nudge(x = -.25), 
       side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
       fill = '#648FFF', alpha = .5) +
    
    geom_half_boxplot(
       data = osn %>% filter(x=="2"), aes(x=x, y = y), position = position_nudge(x = .15), 
       side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
       fill = '#DC267F', alpha = .5) #+
    
    # geom_half_violin(
    #    data = osn %>% filter(x=="1"),aes(x = x, y = y), position = position_nudge(x = -.37), 
    #    side = "l", fill = '#648FFF', alpha = .5, trim = FALSE) +
    # 
    # geom_half_violin(
    #    data = osn %>% filter(x=="2"),aes(x = x, y = y), position = position_nudge(x = .3), 
    #    side = "r", fill = "#DC267F", alpha = .5, trim = FALSE) 
 
 # Define additional settings
 osn_moll_longhigh <-  osn_moll_longhigh + scale_x_continuous(breaks=c(1,2), labels=c("1", "2")) + 
    xlab("Research visit") +
    theme_classic() + 
    theme(plot.title = element_text(hjust = 0.5), axis.text.y = element_blank(), axis.title.y = element_blank()) +
    coord_cartesian(ylim=c(y_lim_min, y_lim_max)) 
 
 # Save png of MOLL graphs 
 png = nullGrob()
 png("moll_vertical.png", width=6, height=10, units="in", res=500)
 multiplot(omni_moll_shortlow, omni_moll_shorthigh, omni_moll_longlow, omni_moll_longhigh, osn_moll_shortlow, osn_moll_shorthigh, osn_moll_longlow, osn_moll_longhigh, cols = 2)
 dev.off()
 
 ########################################################################################################
 
 
 
 ########################################################################################################
 ### NEPSY GRAPH
 y_lim_min = 0
 y_lim_max = 14
 
 omniT1_nepsy = omniT1data$NEPSY_scaled_v1
 omniT2_nepsy = omniT2data$NEPSY_scaled_v1
 osnT1_nepsy = osnT1data$NEPSY_scaled_v1
 osnT2_nepsy = osnT2data$NEPSY_scaled_v1
 n_omni=length(omniT1_nepsy)
 n_osn=length(osnT1_nepsy)
 omni <- data.frame(y = c(omniT1_nepsy, omniT2_nepsy),
                    x = rep(c(1,2), each=n_omni),
                    id = factor(rep(1:n_omni,2)))
 osn <- data.frame(y = c(osnT1_nepsy, osnT2_nepsy),
                   x = rep(c(1,2), each=n_osn),
                   id = factor(rep(1:n_osn,2)))
 
 # omni 
 omni_nepsy <- ggplot(data = omni, aes(y = y)) +
    
    geom_point(data = omni %>% filter(x =="1"), aes(x = x), color = '#785EF0', size = 1.5, 
               alpha = .5) +
    geom_point(data = omni %>% filter(x =="2"), aes(x = x), color = '#FE6100', size = 1.5, 
               alpha = .5) +
    geom_line(aes(x = x, group = id), color = 'grey5', alpha = .5) +
    
    geom_half_boxplot(
       data = omni %>% filter(x=="1"), aes(x=x, y = y), position = position_nudge(x = -.25), 
       side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
       fill = '#785EF0', alpha = .5) +
    
    geom_half_boxplot(
       data = omni %>% filter(x=="2"), aes(x=x, y = y), position = position_nudge(x = .15), 
       side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
       fill = '#FE6100', alpha = .5) #+
    
    # geom_half_violin(
    #    data = omni %>% filter(x=="1"),aes(x = x, y = y), position = position_nudge(x = -.37), 
    #    side = "l", fill = '#785EF0', alpha = .5, trim = FALSE) +
    # 
    # geom_half_violin(
    #    data = omni %>% filter(x=="2"),aes(x = x, y = y), position = position_nudge(x = .3), 
    #    side = "r", fill = "#FE6100", alpha = .5, trim = FALSE) 
 
 # Define additional settings
 omni_nepsy <-  omni_nepsy + scale_x_continuous(breaks=c(1,2), labels=c("1", "2")) + 
    xlab("Research visit") + ylab("Score") +
    ggtitle('omni') +
    theme_classic() + 
    theme(plot.title = element_text(hjust = 0.5)) +
    coord_cartesian(ylim=c(y_lim_min, y_lim_max))
 
 
 # OSN   
 osn_nepsy <- ggplot(data = osn, aes(y = y)) +
    
    geom_point(data = osn %>% filter(x =="1"), aes(x = x), color = '#648FFF', size = 1.5, 
               alpha = .5) +
    geom_point(data = osn %>% filter(x =="2"), aes(x = x), color = '#DC267F', size = 1.5, 
               alpha = .5) +
    geom_line(aes(x = x, group = id), color = 'grey5', alpha = .5) +
    
    geom_half_boxplot(
       data = osn %>% filter(x=="1"), aes(x=x, y = y), position = position_nudge(x = -.25), 
       side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
       fill = '#648FFF', alpha = .5) +
    
    geom_half_boxplot(
       data = osn %>% filter(x=="2"), aes(x=x, y = y), position = position_nudge(x = .15), 
       side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
       fill = '#DC267F', alpha = .5) #+
    
    # geom_half_violin(
    #    data = osn %>% filter(x=="1"),aes(x = x, y = y), position = position_nudge(x = -.37), 
    #    side = "l", fill = '#648FFF', alpha = .5, trim = FALSE) +
    # 
    # geom_half_violin(
    #    data = osn %>% filter(x=="2"),aes(x = x, y = y), position = position_nudge(x = .3), 
    #    side = "r", fill = "#DC267F", alpha = .5, trim = FALSE) 
 
 # Define additional settings
 osn_nepsy <-  osn_nepsy + scale_x_continuous(breaks=c(1,2), labels=c("1", "2")) + 
    xlab("Research visit") + ylab("Standardized score") +
    ggtitle('OSN') +
    theme_classic() + 
    theme(plot.title = element_text(hjust = 0.5), axis.text.y = element_blank(), axis.title.y = element_blank()) +
    coord_cartesian(ylim=c(y_lim_min, y_lim_max))   
 
 # Save png of NEPSY graphs 
 png = nullGrob()
 png("nepsy.png", width=6, height=3, units="in", res=500)
 multiplot(omni_nepsy, osn_nepsy, cols = 2)
 dev.off()
 
 ########################################################################################################
 
 
 
 ########################################################################################################
 ### NIH EARLY SCORE GRAPH
 y_lim_min = 50
 y_lim_max = 150
 
 omniT1_NIH_ECC = omniT1data$NIH_acss_ecc_v1
 omniT2_NIH_ECC = omniT2data$NIH_acss_ecc_v1
 osnT1_NIH_ECC = osnT1data$NIH_acss_ecc_v1
 osnT2_NIH_ECC = osnT2data$NIH_acss_ecc_v1
 n_omni=length(omniT1_NIH_ECC)
 n_osn=length(osnT1_NIH_ECC)
 omni <- data.frame(y = c(omniT1_NIH_ECC, omniT2_NIH_ECC),
                    x = rep(c(1,2), each=n_omni),
                    id = factor(rep(1:n_omni,2)))
 osn <- data.frame(y = c(osnT1_NIH_ECC, osnT2_NIH_ECC),
                   x = rep(c(1,2), each=n_osn),
                   id = factor(rep(1:n_osn,2)))
 
 # omni 
 omni_NIH_ECC <- ggplot(data = omni, aes(y = y)) +
   
   geom_point(data = omni %>% filter(x =="1"), aes(x = x), color = '#785EF0', size = 1.5, 
              alpha = .5) +
   geom_point(data = omni %>% filter(x =="2"), aes(x = x), color = '#FE6100', size = 1.5, 
              alpha = .5) +
   geom_line(aes(x = x, group = id), color = 'grey5', alpha = .5) +
   
   geom_half_boxplot(
     data = omni %>% filter(x=="1"), aes(x=x, y = y), position = position_nudge(x = -.25), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#785EF0', alpha = .5) +
   
   geom_half_boxplot(
     data = omni %>% filter(x=="2"), aes(x=x, y = y), position = position_nudge(x = .15), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#FE6100', alpha = .5) #+
 
 # geom_half_violin(
 #    data = omni %>% filter(x=="1"),aes(x = x, y = y), position = position_nudge(x = -.37), 
 #    side = "l", fill = '#785EF0', alpha = .5, trim = FALSE) +
 # 
 # geom_half_violin(
 #    data = omni %>% filter(x=="2"),aes(x = x, y = y), position = position_nudge(x = .3), 
 #    side = "r", fill = "#FE6100", alpha = .5, trim = FALSE) 
 
 # Define additional settings
 omni_NIH_ECC <-  omni_NIH_ECC + scale_x_continuous(breaks=c(1,2), labels=c("1", "2")) + 
   xlab("Research visit") + ylab("Standardized score") +
   ggtitle('omni') +
   theme_classic() + 
   theme(plot.title = element_text(hjust = 0.5)) +
   coord_cartesian(ylim=c(y_lim_min, y_lim_max))
 
 
 # OSN   
 osn_NIH_ECC <- ggplot(data = osn, aes(y = y)) +
   
   geom_point(data = osn %>% filter(x =="1"), aes(x = x), color = '#648FFF', size = 1.5, 
              alpha = .5) +
   geom_point(data = osn %>% filter(x =="2"), aes(x = x), color = '#DC267F', size = 1.5, 
              alpha = .5) +
   geom_line(aes(x = x, group = id), color = 'grey5', alpha = .5) +
   
   geom_half_boxplot(
     data = osn %>% filter(x=="1"), aes(x=x, y = y), position = position_nudge(x = -.25), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#648FFF', alpha = .5) +
   
   geom_half_boxplot(
     data = osn %>% filter(x=="2"), aes(x=x, y = y), position = position_nudge(x = .15), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#DC267F', alpha = .5) #+
 
 # geom_half_violin(
 #    data = osn %>% filter(x=="1"),aes(x = x, y = y), position = position_nudge(x = -.37), 
 #    side = "l", fill = '#648FFF', alpha = .5, trim = FALSE) +
 # 
 # geom_half_violin(
 #    data = osn %>% filter(x=="2"),aes(x = x, y = y), position = position_nudge(x = .3), 
 #    side = "r", fill = "#DC267F", alpha = .5, trim = FALSE) 
 
 # Define additional settings
 osn_NIH_ECC <-  osn_NIH_ECC + scale_x_continuous(breaks=c(1,2), labels=c("1", "2")) + 
   xlab("Research visit") + ylab("Standardized score") +
   ggtitle('OSN') +
   theme_classic() + 
   theme(plot.title = element_text(hjust = 0.5), axis.text.y = element_blank(), axis.title.y = element_blank()) +
   coord_cartesian(ylim=c(y_lim_min, y_lim_max))   
 
 # Save png of NIH ECC graphs
 png = nullGrob()
 png("NIH_ECC.png", width=6, height=3, units="in", res=500)
 multiplot(omni_NIH_ECC, osn_NIH_ECC, cols = 2)
 dev.off()
 
 ########################################################################################################

 
 
 ########################################################################################################
 ### NIH SUBTEST GRAPHS
 y_lim_min = 50
 y_lim_max = 150
 
 # NIH PIC VOCAB
 omniT1_NIH_PV = omniT1data$NIH_acss_pv_v1
 omniT2_NIH_PV = omniT2data$NIH_acss_pv_v1
 osnT1_NIH_PV = osnT1data$NIH_acss_pv_v1
 osnT2_NIH_PV = osnT2data$NIH_acss_pv_v1
 n_omni=length(omniT1_NIH_PV)
 n_osn=length(osnT1_NIH_PV)
 omni <- data.frame(y = c(omniT1_NIH_PV, omniT2_NIH_PV),
                    x = rep(c(1,2), each=n_omni),
                    id = factor(rep(1:n_omni,2)))
 osn <- data.frame(y = c(osnT1_NIH_PV, osnT2_NIH_PV),
                   x = rep(c(1,2), each=n_osn),
                   id = factor(rep(1:n_osn,2)))
 
 # omni 
 omni_NIH_PV <- ggplot(data = omni, aes(y = y)) +
   
   geom_point(data = omni %>% filter(x =="1"), aes(x = x), color = '#785EF0', size = 1.5, 
              alpha = .5) +
   geom_point(data = omni %>% filter(x =="2"), aes(x = x), color = '#FE6100', size = 1.5, 
              alpha = .5) +
   geom_line(aes(x = x, group = id), color = 'grey5', alpha = .5) +
   
   geom_half_boxplot(
     data = omni %>% filter(x=="1"), aes(x=x, y = y), position = position_nudge(x = -.25), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#785EF0', alpha = .5) +
   
   geom_half_boxplot(
     data = omni %>% filter(x=="2"), aes(x=x, y = y), position = position_nudge(x = .15), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#FE6100', alpha = .5) #+
 
 # geom_half_violin(
 #    data = omni %>% filter(x=="1"),aes(x = x, y = y), position = position_nudge(x = -.37), 
 #    side = "l", fill = '#785EF0', alpha = .5, trim = FALSE) +
 # 
 # geom_half_violin(
 #    data = omni %>% filter(x=="2"),aes(x = x, y = y), position = position_nudge(x = .3), 
 #    side = "r", fill = "#FE6100", alpha = .5, trim = FALSE) 
 
 # Define additional settings
 omni_NIH_PV <-  omni_NIH_PV + scale_x_continuous(breaks=c(1,2)) + 
   ylab("Picture vocabularly") + 
   ggtitle('omni') +
   theme_classic() + 
   theme(plot.title = element_text(hjust = 0.5), axis.text.x = element_blank(), axis.title.x = element_blank()) +
   coord_cartesian(ylim=c(y_lim_min, y_lim_max))
 
 
 # OSN   
 osn_NIH_PV <- ggplot(data = osn, aes(y = y)) +
   
   geom_point(data = osn %>% filter(x =="1"), aes(x = x), color = '#648FFF', size = 1.5, 
              alpha = .5) +
   geom_point(data = osn %>% filter(x =="2"), aes(x = x), color = '#DC267F', size = 1.5, 
              alpha = .5) +
   geom_line(aes(x = x, group = id), color = 'grey5', alpha = .5) +
   
   geom_half_boxplot(
     data = osn %>% filter(x=="1"), aes(x=x, y = y), position = position_nudge(x = -.25), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#648FFF', alpha = .5) +
   
   geom_half_boxplot(
     data = osn %>% filter(x=="2"), aes(x=x, y = y), position = position_nudge(x = .15), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#DC267F', alpha = .5) #+
 
 # geom_half_violin(
 #    data = osn %>% filter(x=="1"),aes(x = x, y = y), position = position_nudge(x = -.37), 
 #    side = "l", fill = '#648FFF', alpha = .5, trim = FALSE) +
 # 
 # geom_half_violin(
 #    data = osn %>% filter(x=="2"),aes(x = x, y = y), position = position_nudge(x = .3), 
 #    side = "r", fill = "#DC267F", alpha = .5, trim = FALSE) 
 
 # Define additional settings
 osn_NIH_PV <-  osn_NIH_PV + scale_x_continuous(breaks=c(1,2)) + 
   ggtitle('OSN') +
   theme_classic() + 
   theme(plot.title = element_text(hjust = 0.5), axis.text.y = element_blank(), axis.title.y = element_blank(), axis.text.x = element_blank(), axis.title.x = element_blank()) +
   coord_cartesian(ylim=c(y_lim_min, y_lim_max)) 
 
 
 # NIH FT
 omniT1_NIH_FT = omniT1data$NIH_acss_ft_v1
 omniT2_NIH_FT = omniT2data$NIH_acss_ft_v1
 osnT1_NIH_FT = osnT1data$NIH_acss_ft_v1
 osnT2_NIH_FT = osnT2data$NIH_acss_ft_v1
 n_omni=length(omniT1_NIH_FT)
 n_osn=length(osnT1_NIH_FT)
 omni <- data.frame(y = c(omniT1_NIH_FT, omniT2_NIH_FT),
                    x = rep(c(1,2), each=n_omni),
                    id = factor(rep(1:n_omni,2)))
 osn <- data.frame(y = c(osnT1_NIH_FT, osnT2_NIH_FT),
                   x = rep(c(1,2), each=n_osn),
                   id = factor(rep(1:n_osn,2)))
 
 # omni 
 omni_NIH_FT <- ggplot(data = omni, aes(y = y)) +
   
   geom_point(data = omni %>% filter(x =="1"), aes(x = x), color = '#785EF0', size = 1.5, 
              alpha = .5) +
   geom_point(data = omni %>% filter(x =="2"), aes(x = x), color = '#FE6100', size = 1.5, 
              alpha = .5) +
   geom_line(aes(x = x, group = id), color = 'grey5', alpha = .5) +
   
   geom_half_boxplot(
     data = omni %>% filter(x=="1"), aes(x=x, y = y), position = position_nudge(x = -.25), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#785EF0', alpha = .5) +
   
   geom_half_boxplot(
     data = omni %>% filter(x=="2"), aes(x=x, y = y), position = position_nudge(x = .15), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#FE6100', alpha = .5) #+
 
 # geom_half_violin(
 #    data = omni %>% filter(x=="1"),aes(x = x, y = y), position = position_nudge(x = -.37), 
 #    side = "l", fill = '#785EF0', alpha = .5, trim = FALSE) +
 # 
 # geom_half_violin(
 #    data = omni %>% filter(x=="2"),aes(x = x, y = y), position = position_nudge(x = .3), 
 #    side = "r", fill = "#FE6100", alpha = .5, trim = FALSE) 
 
 # Define additional settings
 omni_NIH_FT <-  omni_NIH_FT + scale_x_continuous(breaks=c(1,2)) + 
   ylab("Flanker task") +
   theme_classic() + 
   theme(plot.title = element_text(hjust = 0.5), axis.text.x = element_blank(), axis.title.x = element_blank()) +
   coord_cartesian(ylim=c(y_lim_min, y_lim_max))
 
 
 # OSN   
 osn_NIH_FT <- ggplot(data = osn, aes(y = y)) +
   
   geom_point(data = osn %>% filter(x =="1"), aes(x = x), color = '#648FFF', size = 1.5, 
              alpha = .5) +
   geom_point(data = osn %>% filter(x =="2"), aes(x = x), color = '#DC267F', size = 1.5, 
              alpha = .5) +
   geom_line(aes(x = x, group = id), color = 'grey5', alpha = .5) +
   
   geom_half_boxplot(
     data = osn %>% filter(x=="1"), aes(x=x, y = y), position = position_nudge(x = -.25), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#648FFF', alpha = .5) +
   
   geom_half_boxplot(
     data = osn %>% filter(x=="2"), aes(x=x, y = y), position = position_nudge(x = .15), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#DC267F', alpha = .5) #+
 
 # geom_half_violin(
 #    data = osn %>% filter(x=="1"),aes(x = x, y = y), position = position_nudge(x = -.37), 
 #    side = "l", fill = '#648FFF', alpha = .5, trim = FALSE) +
 # 
 # geom_half_violin(
 #    data = osn %>% filter(x=="2"),aes(x = x, y = y), position = position_nudge(x = .3), 
 #    side = "r", fill = "#DC267F", alpha = .5, trim = FALSE) 
 
 # Define additional settings
 osn_NIH_FT <-  osn_NIH_FT + scale_x_continuous(breaks=c(1,2)) + 
   theme_classic() + 
   theme(plot.title = element_text(hjust = 0.5), axis.text.y = element_blank(), axis.title.y = element_blank(), axis.text.x = element_blank(), axis.title.x = element_blank()) +
   coord_cartesian(ylim=c(y_lim_min, y_lim_max)) 
 
 
 # NIH DCCS
 omniT1_NIH_DCCS = omniT1data$NIH_acss_dccs_v1
 omniT2_NIH_DCCS = omniT2data$NIH_acss_dccs_v1
 osnT1_NIH_DCCS = osnT1data$NIH_acss_dccs_v1
 osnT2_NIH_DCCS = osnT2data$NIH_acss_dccs_v1
 n_omni=length(omniT1_NIH_DCCS)
 n_osn=length(osnT1_NIH_DCCS)
 omni <- data.frame(y = c(omniT1_NIH_DCCS, omniT2_NIH_DCCS),
                    x = rep(c(1,2), each=n_omni),
                    id = factor(rep(1:n_omni,2)))
 osn <- data.frame(y = c(osnT1_NIH_DCCS, osnT2_NIH_DCCS),
                   x = rep(c(1,2), each=n_osn),
                   id = factor(rep(1:n_osn,2)))
 
 # omni 
 omni_NIH_DCCS <- ggplot(data = omni, aes(y = y)) +
   
   geom_point(data = omni %>% filter(x =="1"), aes(x = x), color = '#785EF0', size = 1.5, 
              alpha = .5) +
   geom_point(data = omni %>% filter(x =="2"), aes(x = x), color = '#FE6100', size = 1.5, 
              alpha = .5) +
   geom_line(aes(x = x, group = id), color = 'grey5', alpha = .5) +
   
   geom_half_boxplot(
     data = omni %>% filter(x=="1"), aes(x=x, y = y), position = position_nudge(x = -.25), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#785EF0', alpha = .5) +
   
   geom_half_boxplot(
     data = omni %>% filter(x=="2"), aes(x=x, y = y), position = position_nudge(x = .15), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#FE6100', alpha = .5) #+
 
 # geom_half_violin(
 #    data = omni %>% filter(x=="1"),aes(x = x, y = y), position = position_nudge(x = -.37), 
 #    side = "l", fill = '#785EF0', alpha = .5, trim = FALSE) +
 # 
 # geom_half_violin(
 #    data = omni %>% filter(x=="2"),aes(x = x, y = y), position = position_nudge(x = .3), 
 #    side = "r", fill = "#FE6100", alpha = .5, trim = FALSE) 
 
 # Define additional settings
 omni_NIH_DCCS <-  omni_NIH_DCCS + scale_x_continuous(breaks=c(1,2)) + 
   ylab("Dimmensional card sorting task") +
   theme_classic() + 
   theme(plot.title = element_text(hjust = 0.5), axis.text.x = element_blank(), axis.title.x = element_blank()) +
   coord_cartesian(ylim=c(y_lim_min, y_lim_max))
 
 
 # OSN   
 osn_NIH_DCCS <- ggplot(data = osn, aes(y = y)) +
   
   geom_point(data = osn %>% filter(x =="1"), aes(x = x), color = '#648FFF', size = 1.5, 
              alpha = .5) +
   geom_point(data = osn %>% filter(x =="2"), aes(x = x), color = '#DC267F', size = 1.5, 
              alpha = .5) +
   geom_line(aes(x = x, group = id), color = 'grey5', alpha = .5) +
   
   geom_half_boxplot(
     data = osn %>% filter(x=="1"), aes(x=x, y = y), position = position_nudge(x = -.25), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#648FFF', alpha = .5) +
   
   geom_half_boxplot(
     data = osn %>% filter(x=="2"), aes(x=x, y = y), position = position_nudge(x = .15), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#DC267F', alpha = .5) #+
 
 # geom_half_violin(
 #    data = osn %>% filter(x=="1"),aes(x = x, y = y), position = position_nudge(x = -.37), 
 #    side = "l", fill = '#648FFF', alpha = .5, trim = FALSE) +
 # 
 # geom_half_violin(
 #    data = osn %>% filter(x=="2"),aes(x = x, y = y), position = position_nudge(x = .3), 
 #    side = "r", fill = "#DC267F", alpha = .5, trim = FALSE) 
 
 # Define additional settings
 osn_NIH_DCCS <-  osn_NIH_DCCS + scale_x_continuous(breaks=c(1,2)) + 
   theme_classic() + 
   theme(plot.title = element_text(hjust = 0.5), axis.text.y = element_blank(), axis.title.y = element_blank(), axis.text.x = element_blank(), axis.title.x = element_blank()) +
   coord_cartesian(ylim=c(y_lim_min, y_lim_max)) 
 
 
 # MNIH PS (memory)
 omniT1_NIH_PS = omniT1data$NIH_acss_ps_v1
 omniT2_NIH_PS = omniT2data$NIH_acss_ps_v1
 osnT1_NIH_PS = osnT1data$NIH_acss_ps_v1
 osnT2_NIH_PS = osnT2data$NIH_acss_ps_v1
 n_omni=length(omniT1_NIH_PS)
 n_osn=length(osnT1_NIH_PS)
 omni <- data.frame(y = c(omniT1_NIH_PS, omniT2_NIH_PS),
                    x = rep(c(1,2), each=n_omni),
                    id = factor(rep(1:n_omni,2)))
 osn <- data.frame(y = c(osnT1_NIH_PS, osnT2_NIH_PS),
                   x = rep(c(1,2), each=n_osn),
                   id = factor(rep(1:n_osn,2)))
 
 # omni 
 omni_NIH_PS <- ggplot(data = omni, aes(y = y)) +
   
   geom_point(data = omni %>% filter(x =="1"), aes(x = x), color = '#785EF0', size = 1.5, 
              alpha = .5) +
   geom_point(data = omni %>% filter(x =="2"), aes(x = x), color = '#FE6100', size = 1.5, 
              alpha = .5) +
   geom_line(aes(x = x, group = id), color = 'grey5', alpha = .5) +
   
   geom_half_boxplot(
     data = omni %>% filter(x=="1"), aes(x=x, y = y), position = position_nudge(x = -.25), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#785EF0', alpha = .5) +
   
   geom_half_boxplot(
     data = omni %>% filter(x=="2"), aes(x=x, y = y), position = position_nudge(x = .15), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#FE6100', alpha = .5) #+
 
 # geom_half_violin(
 #    data = omni %>% filter(x=="1"),aes(x = x, y = y), position = position_nudge(x = -.37), 
 #    side = "l", fill = '#785EF0', alpha = .5, trim = FALSE) +
 # 
 # geom_half_violin(
 #    data = omni %>% filter(x=="2"),aes(x = x, y = y), position = position_nudge(x = .3), 
 #    side = "r", fill = "#FE6100", alpha = .5, trim = FALSE) 
 
 # Define additional settings
 omni_NIH_PS <-  omni_NIH_PS + scale_x_continuous(breaks=c(1,2), labels=c("1", "2")) + 
   xlab("Research visit") + ylab("Picture squence memory test") +
   theme_classic() + 
   theme(plot.title = element_text(hjust = 0.5)) +
   coord_cartesian(ylim=c(y_lim_min, y_lim_max))
 
 
 # OSN   
 osn_NIH_PS <- ggplot(data = osn, aes(y = y)) +
   
   geom_point(data = osn %>% filter(x =="1"), aes(x = x), color = '#648FFF', size = 1.5, 
              alpha = .5) +
   geom_point(data = osn %>% filter(x =="2"), aes(x = x), color = '#DC267F', size = 1.5, 
              alpha = .5) +
   geom_line(aes(x = x, group = id), color = 'grey5', alpha = .5) +
   
   geom_half_boxplot(
     data = osn %>% filter(x=="1"), aes(x=x, y = y), position = position_nudge(x = -.25), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#648FFF', alpha = .5) +
   
   geom_half_boxplot(
     data = osn %>% filter(x=="2"), aes(x=x, y = y), position = position_nudge(x = .15), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#DC267F', alpha = .5) #+
 
 # geom_half_violin(
 #    data = osn %>% filter(x=="1"),aes(x = x, y = y), position = position_nudge(x = -.37), 
 #    side = "l", fill = '#648FFF', alpha = .5, trim = FALSE) +
 # 
 # geom_half_violin(
 #    data = osn %>% filter(x=="2"),aes(x = x, y = y), position = position_nudge(x = .3), 
 #    side = "r", fill = "#DC267F", alpha = .5, trim = FALSE) 
 
 # Define additional settings
 osn_NIH_PS <-  osn_NIH_PS + scale_x_continuous(breaks=c(1,2), labels=c("1", "2")) + 
   xlab("Research visit") +
   theme_classic() + 
   theme(plot.title = element_text(hjust = 0.5), axis.text.y = element_blank(), axis.title.y = element_blank()) +
   coord_cartesian(ylim=c(y_lim_min, y_lim_max)) 
 
 # Save png of NIH subtest graphs 
 png = nullGrob()
 png("NIH_vertical.png", width=6, height=10, units="in", res=500)
 multiplot(omni_NIH_PV, omni_NIH_FT, omni_NIH_DCCS, omni_NIH_PS, osn_NIH_PV, osn_NIH_FT, osn_NIH_DCCS, osn_NIH_PS, cols = 2)
 dev.off()
 
 ########################################################################################################
 
 
 
 ########################################################################################################
 ### WJ-IV GRAPHS
 y_lim_min = 50
 y_lim_max = 150
 
 # WJ-IV READING
 omniT1_WJ_reading = omniT1data$WJ_reading_standardScore_v1
 omniT2_WJ_reading = omniT2data$WJ_reading_standardScore_v1
 osnT1_WJ_reading = osnT1data$WJ_reading_standardScore_v1
 osnT2_WJ_reading = osnT2data$WJ_reading_standardScore_v1
 n_omni=length(omniT1_WJ_reading)
 n_osn=length(osnT1_WJ_reading)
 omni <- data.frame(y = c(omniT1_WJ_reading, omniT2_WJ_reading),
                    x = rep(c(1,2), each=n_omni),
                    id = factor(rep(1:n_omni,2)))
 osn <- data.frame(y = c(osnT1_WJ_reading, osnT2_WJ_reading),
                   x = rep(c(1,2), each=n_osn),
                   id = factor(rep(1:n_osn,2)))
 
 # omni 
 omni_WJ_reading <- ggplot(data = omni, aes(y = y)) +
   
   geom_point(data = omni %>% filter(x =="1"), aes(x = x), color = '#785EF0', size = 1.5, 
              alpha = .5) +
   geom_point(data = omni %>% filter(x =="2"), aes(x = x), color = '#FE6100', size = 1.5, 
              alpha = .5) +
   geom_line(aes(x = x, group = id), color = 'grey5', alpha = .5) +
   
   geom_half_boxplot(
     data = omni %>% filter(x=="1"), aes(x=x, y = y), position = position_nudge(x = -.25), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#785EF0', alpha = .5) +
   
   geom_half_boxplot(
     data = omni %>% filter(x=="2"), aes(x=x, y = y), position = position_nudge(x = .15), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#FE6100', alpha = .5) #+
 
 # geom_half_violin(
 #    data = omni %>% filter(x=="1"),aes(x = x, y = y), position = position_nudge(x = -.37), 
 #    side = "l", fill = '#785EF0', alpha = .5, trim = FALSE) +
 # 
 # geom_half_violin(
 #    data = omni %>% filter(x=="2"),aes(x = x, y = y), position = position_nudge(x = .3), 
 #    side = "r", fill = "#FE6100", alpha = .5, trim = FALSE) 
 
 # Define additional settings
 omni_WJ_reading <-  omni_WJ_reading + scale_x_continuous(breaks=c(1,2)) + 
   ylab("Reading") + 
   ggtitle('omni') +
   theme_classic() + 
   theme(plot.title = element_text(hjust = 0.5), axis.text.x = element_blank(), axis.title.x = element_blank()) +
   coord_cartesian(ylim=c(y_lim_min, y_lim_max))
 
 
 # OSN   
 osn_WJ_reading <- ggplot(data = osn, aes(y = y)) +
   
   geom_point(data = osn %>% filter(x =="1"), aes(x = x), color = '#648FFF', size = 1.5, 
              alpha = .5) +
   geom_point(data = osn %>% filter(x =="2"), aes(x = x), color = '#DC267F', size = 1.5, 
              alpha = .5) +
   geom_line(aes(x = x, group = id), color = 'grey5', alpha = .5) +
   
   geom_half_boxplot(
     data = osn %>% filter(x=="1"), aes(x=x, y = y), position = position_nudge(x = -.25), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#648FFF', alpha = .5) +
   
   geom_half_boxplot(
     data = osn %>% filter(x=="2"), aes(x=x, y = y), position = position_nudge(x = .15), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#DC267F', alpha = .5) #+
 
 # geom_half_violin(
 #    data = osn %>% filter(x=="1"),aes(x = x, y = y), position = position_nudge(x = -.37), 
 #    side = "l", fill = '#648FFF', alpha = .5, trim = FALSE) +
 # 
 # geom_half_violin(
 #    data = osn %>% filter(x=="2"),aes(x = x, y = y), position = position_nudge(x = .3), 
 #    side = "r", fill = "#DC267F", alpha = .5, trim = FALSE) 
 
 # Define additional settings
 osn_WJ_reading <-  osn_WJ_reading + scale_x_continuous(breaks=c(1,2)) + 
   ggtitle('OSN') +
   theme_classic() + 
   theme(plot.title = element_text(hjust = 0.5), axis.text.y = element_blank(), axis.title.y = element_blank(), axis.text.x = element_blank(), axis.title.x = element_blank()) +
   coord_cartesian(ylim=c(y_lim_min, y_lim_max)) 
 
 # WJ MATH
 omniT1_WJ_math = omniT1data$WJ_math_standardScore_v1
 omniT2_WJ_math = omniT2data$WJ_math_standardScore_v1
 osnT1_WJ_math = osnT1data$WJ_math_standardScore_v1
 osnT2_WJ_math = osnT2data$WJ_math_standardScore_v1
 n_omni=length(omniT1_WJ_math)
 n_osn=length(osnT1_WJ_math)
 omni <- data.frame(y = c(omniT1_WJ_math, omniT2_WJ_math),
                    x = rep(c(1,2), each=n_omni),
                    id = factor(rep(1:n_omni,2)))
 osn <- data.frame(y = c(osnT1_WJ_math, osnT2_WJ_math),
                   x = rep(c(1,2), each=n_osn),
                   id = factor(rep(1:n_osn,2)))
 
 # omni 
 omni_WJ_math <- ggplot(data = omni, aes(y = y)) +
   
   geom_point(data = omni %>% filter(x =="1"), aes(x = x), color = '#785EF0', size = 1.5, 
              alpha = .5) +
   geom_point(data = omni %>% filter(x =="2"), aes(x = x), color = '#FE6100', size = 1.5, 
              alpha = .5) +
   geom_line(aes(x = x, group = id), color = 'grey5', alpha = .5) +
   
   geom_half_boxplot(
     data = omni %>% filter(x=="1"), aes(x=x, y = y), position = position_nudge(x = -.25), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#785EF0', alpha = .5) +
   
   geom_half_boxplot(
     data = omni %>% filter(x=="2"), aes(x=x, y = y), position = position_nudge(x = .15), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#FE6100', alpha = .5) #+
 
 # geom_half_violin(
 #    data = omni %>% filter(x=="1"),aes(x = x, y = y), position = position_nudge(x = -.37), 
 #    side = "l", fill = '#785EF0', alpha = .5, trim = FALSE) +
 # 
 # geom_half_violin(
 #    data = omni %>% filter(x=="2"),aes(x = x, y = y), position = position_nudge(x = .3), 
 #    side = "r", fill = "#FE6100", alpha = .5, trim = FALSE) 
 
 # Define additional settings
 omni_WJ_math <-  omni_WJ_math + scale_x_continuous(breaks=c(1,2), labels=c("1", "2")) + 
   xlab("Research visit") + ylab("Mathematics") +
   theme_classic() + 
   theme(plot.title = element_text(hjust = 0.5)) +
   coord_cartesian(ylim=c(y_lim_min, y_lim_max))
 
 
 # OSN   
 osn_WJ_math <- ggplot(data = osn, aes(y = y)) +
   
   geom_point(data = osn %>% filter(x =="1"), aes(x = x), color = '#648FFF', size = 1.5, 
              alpha = .5) +
   geom_point(data = osn %>% filter(x =="2"), aes(x = x), color = '#DC267F', size = 1.5, 
              alpha = .5) +
   geom_line(aes(x = x, group = id), color = 'grey5', alpha = .5) +
   
   geom_half_boxplot(
     data = osn %>% filter(x=="1"), aes(x=x, y = y), position = position_nudge(x = -.25), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#648FFF', alpha = .5) +
   
   geom_half_boxplot(
     data = osn %>% filter(x=="2"), aes(x=x, y = y), position = position_nudge(x = .15), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#DC267F', alpha = .5) #+
 
 # geom_half_violin(
 #    data = osn %>% filter(x=="1"),aes(x = x, y = y), position = position_nudge(x = -.37), 
 #    side = "l", fill = '#648FFF', alpha = .5, trim = FALSE) +
 # 
 # geom_half_violin(
 #    data = osn %>% filter(x=="2"),aes(x = x, y = y), position = position_nudge(x = .3), 
 #    side = "r", fill = "#DC267F", alpha = .5, trim = FALSE) 
 
 # Define additional settings
 osn_WJ_math <-  osn_WJ_math + scale_x_continuous(breaks=c(1,2), labels=c("1", "2")) + 
   xlab("Research visit") +
   theme_classic() + 
   theme(plot.title = element_text(hjust = 0.5), axis.text.y = element_blank(), axis.title.y = element_blank()) +
   coord_cartesian(ylim=c(y_lim_min, y_lim_max)) 
 
 # Save png of WJIV graphs 
 png = nullGrob()
 png("wj_vertical.png", width=6, height=5, units="in", res=500)
 multiplot(omni_WJ_reading, omni_WJ_math, osn_WJ_reading, osn_WJ_math, cols = 2)
 dev.off()
 
 ########################################################################################################
 
 
 
 ########################################################################################################
 ### GLASGOW GRAPH
 y_lim_min = -15
 y_lim_max = 75
 
 omniT1_glasgow = omniT1data$GCBI_score1_v1
 omniT2_glasgow = omniT2data$GCBI_score1_v1
 osnT1_glasgow = osnT1data$GCBI_score1_v1
 osnT2_glasgow = osnT2data$GCBI_score1_v1
 n_omni=length(omniT1_glasgow)
 n_osn=length(osnT1_glasgow)
 omni <- data.frame(y = c(omniT1_glasgow, omniT2_glasgow),
                    x = rep(c(1,2), each=n_omni),
                    id = factor(rep(1:n_omni,2)))
 osn <- data.frame(y = c(osnT1_glasgow, osnT2_glasgow),
                   x = rep(c(1,2), each=n_osn),
                   id = factor(rep(1:n_osn,2)))
 
 # omni 
 omni_glasgow <- ggplot(data = omni, aes(y = y)) +
   
   geom_point(data = omni %>% filter(x =="1"), aes(x = x), color = '#785EF0', size = 1.5, 
              alpha = .5) +
   geom_point(data = omni %>% filter(x =="2"), aes(x = x), color = '#FE6100', size = 1.5, 
              alpha = .5) +
   geom_line(aes(x = x, group = id), color = 'grey5', alpha = .5) +
   
   geom_half_boxplot(
     data = omni %>% filter(x=="1"), aes(x=x, y = y), position = position_nudge(x = -.25), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#785EF0', alpha = .5) +
   
   geom_half_boxplot(
     data = omni %>% filter(x=="2"), aes(x=x, y = y), position = position_nudge(x = .15), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#FE6100', alpha = .5) #+
 
 # geom_half_violin(
 #    data = omni %>% filter(x=="1"),aes(x = x, y = y), position = position_nudge(x = -.37), 
 #    side = "l", fill = '#785EF0', alpha = .5, trim = FALSE) +
 # 
 # geom_half_violin(
 #    data = omni %>% filter(x=="2"),aes(x = x, y = y), position = position_nudge(x = .3), 
 #    side = "r", fill = "#FE6100", alpha = .5, trim = FALSE) 
 
 # Define additional settings
 omni_glasgow <-  omni_glasgow + scale_x_continuous(breaks=c(1,2), labels=c("1", "2")) + 
   xlab("Research visit") + ylab("Score") +
   ggtitle('omni') +
   theme_classic() + 
   theme(plot.title = element_text(hjust = 0.5)) +
   coord_cartesian(ylim=c(y_lim_min, y_lim_max))
 
 
 # OSN   
 osn_glasgow <- ggplot(data = osn, aes(y = y)) +
   
   geom_point(data = osn %>% filter(x =="1"), aes(x = x), color = '#648FFF', size = 1.5, 
              alpha = .5) +
   geom_point(data = osn %>% filter(x =="2"), aes(x = x), color = '#DC267F', size = 1.5, 
              alpha = .5) +
   geom_line(aes(x = x, group = id), color = 'grey5', alpha = .5) +
   
   geom_half_boxplot(
     data = osn %>% filter(x=="1"), aes(x=x, y = y), position = position_nudge(x = -.25), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#648FFF', alpha = .5) +
   
   geom_half_boxplot(
     data = osn %>% filter(x=="2"), aes(x=x, y = y), position = position_nudge(x = .15), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#DC267F', alpha = .5) #+
 
 # geom_half_violin(
 #    data = osn %>% filter(x=="1"),aes(x = x, y = y), position = position_nudge(x = -.37), 
 #    side = "l", fill = '#648FFF', alpha = .5, trim = FALSE) +
 # 
 # geom_half_violin(
 #    data = osn %>% filter(x=="2"),aes(x = x, y = y), position = position_nudge(x = .3), 
 #    side = "r", fill = "#DC267F", alpha = .5, trim = FALSE) 
 
 # Define additional settings
 osn_glasgow <-  osn_glasgow + scale_x_continuous(breaks=c(1,2), labels=c("1", "2")) + 
   xlab("Research visit") + ylab("Score") +
   ggtitle('OSN') +
   theme_classic() + 
   theme(plot.title = element_text(hjust = 0.5), axis.text.y = element_blank(), axis.title.y = element_blank()) +
   coord_cartesian(ylim=c(y_lim_min, y_lim_max))   
 
 # Save png of GLASGOW graphs 
 png = nullGrob()
 png("glasgow.png", width=6, height=3, units="in", res=500)
 multiplot(omni_glasgow, osn_glasgow, cols = 2)
 dev.off()
 
 ########################################################################################################
 
 
 
 ########################################################################################################
 ### SSQ GRAPHS
 y_lim_min = 0
 y_lim_max = 100
 
 # SSQ Speech
 omniT1_SSQ_speech = omniT1data$SSQ_speech_score_v1
 omniT2_SSQ_speech= omniT2data$SSQ_speech_score_v1
 osnT1_SSQ_speech = osnT1data$SSQ_speech_score_v1
 osnT2_SSQ_speech = osnT2data$SSQ_speech_score_v1
 n_omni=length(omniT1_SSQ_speech)
 n_osn=length(osnT1_SSQ_speech)
 omni <- data.frame(y = c(omniT1_SSQ_speech, omniT2_SSQ_speech),
                    x = rep(c(1,2), each=n_omni),
                    id = factor(rep(1:n_omni,2)))
 osn <- data.frame(y = c(osnT1_SSQ_speech, osnT2_SSQ_speech),
                   x = rep(c(1,2), each=n_osn),
                   id = factor(rep(1:n_osn,2)))
 
 # omni 
 omni_SSQ_speech <- ggplot(data = omni, aes(y = y)) +
   
   geom_point(data = omni %>% filter(x =="1"), aes(x = x), color = '#785EF0', size = 1.5, 
              alpha = .5) +
   geom_point(data = omni %>% filter(x =="2"), aes(x = x), color = '#FE6100', size = 1.5, 
              alpha = .5) +
   geom_line(aes(x = x, group = id), color = 'grey5', alpha = .5) +
   
   geom_half_boxplot(
     data = omni %>% filter(x=="1"), aes(x=x, y = y), position = position_nudge(x = -.25), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#785EF0', alpha = .5) +
   
   geom_half_boxplot(
     data = omni %>% filter(x=="2"), aes(x=x, y = y), position = position_nudge(x = .15), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#FE6100', alpha = .5) #+
 
 # geom_half_violin(
 #    data = omni %>% filter(x=="1"),aes(x = x, y = y), position = position_nudge(x = -.37), 
 #    side = "l", fill = '#785EF0', alpha = .5, trim = FALSE) +
 # 
 # geom_half_violin(
 #    data = omni %>% filter(x=="2"),aes(x = x, y = y), position = position_nudge(x = .3), 
 #    side = "r", fill = "#FE6100", alpha = .5, trim = FALSE) 
 
 # Define additional settings
 omni_SSQ_speech <-  omni_SSQ_speech + scale_x_continuous(breaks=c(1,2)) + 
   ylab("Speech \n Score") + 
   ggtitle('omni') +
   theme_classic() + 
   theme(plot.title = element_text(hjust = 0.5), axis.text.x = element_blank(), axis.title.x = element_blank()) +
   coord_cartesian(ylim=c(y_lim_min, y_lim_max))
 
 
 # OSN   
 osn_SSQ_speech <- ggplot(data = osn, aes(y = y)) +
   
   geom_point(data = osn %>% filter(x =="1"), aes(x = x), color = '#648FFF', size = 1.5, 
              alpha = .5) +
   geom_point(data = osn %>% filter(x =="2"), aes(x = x), color = '#DC267F', size = 1.5, 
              alpha = .5) +
   geom_line(aes(x = x, group = id), color = 'grey5', alpha = .5) +
   
   geom_half_boxplot(
     data = osn %>% filter(x=="1"), aes(x=x, y = y), position = position_nudge(x = -.25), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#648FFF', alpha = .5) +
   
   geom_half_boxplot(
     data = osn %>% filter(x=="2"), aes(x=x, y = y), position = position_nudge(x = .15), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#DC267F', alpha = .5) #+
 
 # geom_half_violin(
 #    data = osn %>% filter(x=="1"),aes(x = x, y = y), position = position_nudge(x = -.37), 
 #    side = "l", fill = '#648FFF', alpha = .5, trim = FALSE) +
 # 
 # geom_half_violin(
 #    data = osn %>% filter(x=="2"),aes(x = x, y = y), position = position_nudge(x = .3), 
 #    side = "r", fill = "#DC267F", alpha = .5, trim = FALSE) 
 
 # Define additional settings
 osn_SSQ_speech <-  osn_SSQ_speech + scale_x_continuous(breaks=c(1,2)) + 
   ggtitle('OSN') +
   theme_classic() + 
   theme(plot.title = element_text(hjust = 0.5), axis.text.y = element_blank(), axis.title.y = element_blank(), axis.text.x = element_blank(), axis.title.x = element_blank()) +
   coord_cartesian(ylim=c(y_lim_min, y_lim_max)) 
 
 
 # SSQ Spatial
 omniT1_SSQ_spatial = omniT1data$SSQ_spatial_score_v1
 omniT2_SSQ_spatial = omniT2data$SSQ_spatial_score_v1
 osnT1_SSQ_spatial = osnT1data$SSQ_spatial_score_v1
 osnT2_SSQ_spatial = osnT2data$SSQ_spatial_score_v1
 n_omni=length(omniT1_SSQ_spatial)
 n_osn=length(osnT1_SSQ_spatial)
 omni <- data.frame(y = c(omniT1_SSQ_spatial, omniT2_SSQ_spatial),
                    x = rep(c(1,2), each=n_omni),
                    id = factor(rep(1:n_omni,2)))
 osn <- data.frame(y = c(osnT1_SSQ_spatial, osnT2_SSQ_spatial),
                   x = rep(c(1,2), each=n_osn),
                   id = factor(rep(1:n_osn,2)))
 
 # omni 
 omni_SSQ_spatial <- ggplot(data = omni, aes(y = y)) +
   
   geom_point(data = omni %>% filter(x =="1"), aes(x = x), color = '#785EF0', size = 1.5, 
              alpha = .5) +
   geom_point(data = omni %>% filter(x =="2"), aes(x = x), color = '#FE6100', size = 1.5, 
              alpha = .5) +
   geom_line(aes(x = x, group = id), color = 'grey5', alpha = .5) +
   
   geom_half_boxplot(
     data = omni %>% filter(x=="1"), aes(x=x, y = y), position = position_nudge(x = -.25), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#785EF0', alpha = .5) +
   
   geom_half_boxplot(
     data = omni %>% filter(x=="2"), aes(x=x, y = y), position = position_nudge(x = .15), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#FE6100', alpha = .5) #+
 
 # geom_half_violin(
 #    data = omni %>% filter(x=="1"),aes(x = x, y = y), position = position_nudge(x = -.37), 
 #    side = "l", fill = '#785EF0', alpha = .5, trim = FALSE) +
 # 
 # geom_half_violin(
 #    data = omni %>% filter(x=="2"),aes(x = x, y = y), position = position_nudge(x = .3), 
 #    side = "r", fill = "#FE6100", alpha = .5, trim = FALSE) 
 
 # Define additional settings
 omni_SSQ_spatial <-  omni_SSQ_spatial + scale_x_continuous(breaks=c(1,2)) + 
   ylab("Spatial \n Score") +
   theme_classic() + 
   theme(plot.title = element_text(hjust = 0.5), axis.text.x = element_blank(), axis.title.x = element_blank()) +
   coord_cartesian(ylim=c(y_lim_min, y_lim_max))
 
 
 # OSN   
 osn_SSQ_spatial <- ggplot(data = osn, aes(y = y)) +
   
   geom_point(data = osn %>% filter(x =="1"), aes(x = x), color = '#648FFF', size = 1.5, 
              alpha = .5) +
   geom_point(data = osn %>% filter(x =="2"), aes(x = x), color = '#DC267F', size = 1.5, 
              alpha = .5) +
   geom_line(aes(x = x, group = id), color = 'grey5', alpha = .5) +
   
   geom_half_boxplot(
     data = osn %>% filter(x=="1"), aes(x=x, y = y), position = position_nudge(x = -.25), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#648FFF', alpha = .5) +
   
   geom_half_boxplot(
     data = osn %>% filter(x=="2"), aes(x=x, y = y), position = position_nudge(x = .15), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#DC267F', alpha = .5) #+
 
 # geom_half_violin(
 #    data = osn %>% filter(x=="1"),aes(x = x, y = y), position = position_nudge(x = -.37), 
 #    side = "l", fill = '#648FFF', alpha = .5, trim = FALSE) +
 # 
 # geom_half_violin(
 #    data = osn %>% filter(x=="2"),aes(x = x, y = y), position = position_nudge(x = .3), 
 #    side = "r", fill = "#DC267F", alpha = .5, trim = FALSE) 
 
 # Define additional settings
 osn_SSQ_spatial <- osn_SSQ_spatial + scale_x_continuous(breaks=c(1,2)) + 
   theme_classic() + 
   theme(plot.title = element_text(hjust = 0.5), axis.text.y = element_blank(), axis.title.y = element_blank(), axis.text.x = element_blank(), axis.title.x = element_blank()) +
   coord_cartesian(ylim=c(y_lim_min, y_lim_max)) 
 
 
 # SSQ Qualities
 omniT1_SSQ_qualities = omniT1data$SSQ_quality_score_2_v1
 omniT2_SSQ_qualities = omniT2data$SSQ_quality_score_2_v1
 osnT1_SSQ_qualities = osnT1data$SSQ_quality_score_2_v1
 osnT2_SSQ_qualities = osnT2data$SSQ_quality_score_2_v1
 n_omni=length(omniT1_SSQ_qualities)
 n_osn=length(osnT1_SSQ_qualities)
 omni <- data.frame(y = c(omniT1_SSQ_qualities, omniT2_SSQ_qualities),
                    x = rep(c(1,2), each=n_omni),
                    id = factor(rep(1:n_omni,2)))
 osn <- data.frame(y = c(osnT1_SSQ_qualities, osnT2_SSQ_qualities),
                   x = rep(c(1,2), each=n_osn),
                   id = factor(rep(1:n_osn,2)))
 
 # omni 
 omni_SSQ_qualities <- ggplot(data = omni, aes(y = y)) +
   
   geom_point(data = omni %>% filter(x =="1"), aes(x = x), color = '#785EF0', size = 1.5, 
              alpha = .5) +
   geom_point(data = omni %>% filter(x =="2"), aes(x = x), color = '#FE6100', size = 1.5, 
              alpha = .5) +
   geom_line(aes(x = x, group = id), color = 'grey5', alpha = .5) +
   
   geom_half_boxplot(
     data = omni %>% filter(x=="1"), aes(x=x, y = y), position = position_nudge(x = -.25), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#785EF0', alpha = .5) +
   
   geom_half_boxplot(
     data = omni %>% filter(x=="2"), aes(x=x, y = y), position = position_nudge(x = .15), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#FE6100', alpha = .5) #+
 
 # geom_half_violin(
 #    data = omni %>% filter(x=="1"),aes(x = x, y = y), position = position_nudge(x = -.37), 
 #    side = "l", fill = '#785EF0', alpha = .5, trim = FALSE) +
 # 
 # geom_half_violin(
 #    data = omni %>% filter(x=="2"),aes(x = x, y = y), position = position_nudge(x = .3), 
 #    side = "r", fill = "#FE6100", alpha = .5, trim = FALSE) 
 
 # Define additional settings
 omni_SSQ_qualities <-  omni_SSQ_qualities + scale_x_continuous(breaks=c(1,2)) + 
   ylab("Qualities \n Score") +
   theme_classic() + 
   theme(plot.title = element_text(hjust = 0.5), axis.text.x = element_blank(), axis.title.x = element_blank()) +
   coord_cartesian(ylim=c(y_lim_min, y_lim_max))
 
 
 # OSN   
 osn_SSQ_qualities <- ggplot(data = osn, aes(y = y)) +
   
   geom_point(data = osn %>% filter(x =="1"), aes(x = x), color = '#648FFF', size = 1.5, 
              alpha = .5) +
   geom_point(data = osn %>% filter(x =="2"), aes(x = x), color = '#DC267F', size = 1.5, 
              alpha = .5) +
   geom_line(aes(x = x, group = id), color = 'grey5', alpha = .5) +
   
   geom_half_boxplot(
     data = osn %>% filter(x=="1"), aes(x=x, y = y), position = position_nudge(x = -.25), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#648FFF', alpha = .5) +
   
   geom_half_boxplot(
     data = osn %>% filter(x=="2"), aes(x=x, y = y), position = position_nudge(x = .15), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#DC267F', alpha = .5) #+
 
 # geom_half_violin(
 #    data = osn %>% filter(x=="1"),aes(x = x, y = y), position = position_nudge(x = -.37), 
 #    side = "l", fill = '#648FFF', alpha = .5, trim = FALSE) +
 # 
 # geom_half_violin(
 #    data = osn %>% filter(x=="2"),aes(x = x, y = y), position = position_nudge(x = .3), 
 #    side = "r", fill = "#DC267F", alpha = .5, trim = FALSE) 
 
 # Define additional settings
 osn_SSQ_qualities <-  osn_SSQ_qualities + scale_x_continuous(breaks=c(1,2)) + 
   theme_classic() + 
   theme(plot.title = element_text(hjust = 0.5), axis.text.y = element_blank(), axis.title.y = element_blank(), axis.text.x = element_blank(), axis.title.x = element_blank()) +
   coord_cartesian(ylim=c(y_lim_min, y_lim_max)) 
 
 
 # SSQ Conversation
 omniT1_SSQ_converse = omniT1data$SSQ_converse_score_v1
 omniT2_SSQ_converse = omniT2data$SSQ_converse_score_v1
 osnT1_SSQ_converse = osnT1data$SSQ_converse_score_v1
 osnT2_SSQ_converse = osnT2data$SSQ_converse_score_v1
 n_omni=length(omniT1_SSQ_converse)
 n_osn=length(osnT1_SSQ_converse)
 omni <- data.frame(y = c(omniT1_SSQ_converse, omniT2_SSQ_converse),
                    x = rep(c(1,2), each=n_omni),
                    id = factor(rep(1:n_omni,2)))
 osn <- data.frame(y = c(osnT1_SSQ_converse, osnT2_SSQ_converse),
                   x = rep(c(1,2), each=n_osn),
                   id = factor(rep(1:n_osn,2)))
 
 # omni 
 omni_SSQ_converse <- ggplot(data = omni, aes(y = y)) +
   
   geom_point(data = omni %>% filter(x =="1"), aes(x = x), color = '#785EF0', size = 1.5, 
              alpha = .5) +
   geom_point(data = omni %>% filter(x =="2"), aes(x = x), color = '#FE6100', size = 1.5, 
              alpha = .5) +
   geom_line(aes(x = x, group = id), color = 'grey5', alpha = .5) +
   
   geom_half_boxplot(
     data = omni %>% filter(x=="1"), aes(x=x, y = y), position = position_nudge(x = -.25), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#785EF0', alpha = .5) +
   
   geom_half_boxplot(
     data = omni %>% filter(x=="2"), aes(x=x, y = y), position = position_nudge(x = .15), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#FE6100', alpha = .5) #+
 
 # geom_half_violin(
 #    data = omni %>% filter(x=="1"),aes(x = x, y = y), position = position_nudge(x = -.37), 
 #    side = "l", fill = '#785EF0', alpha = .5, trim = FALSE) +
 # 
 # geom_half_violin(
 #    data = omni %>% filter(x=="2"),aes(x = x, y = y), position = position_nudge(x = .3), 
 #    side = "r", fill = "#FE6100", alpha = .5, trim = FALSE) 
 
 # Define additional settings
 omni_SSQ_converse <-  omni_SSQ_converse + scale_x_continuous(breaks=c(1,2), labels=c("1", "2")) + 
   xlab("Research visit") + ylab("Conversation \n Score") +
   theme_classic() + 
   theme(plot.title = element_text(hjust = 0.5)) +
   coord_cartesian(ylim=c(y_lim_min, y_lim_max))
 
 
 # OSN   
 osn_SSQ_converse <- ggplot(data = osn, aes(y = y)) +
   
   geom_point(data = osn %>% filter(x =="1"), aes(x = x), color = '#648FFF', size = 1.5, 
              alpha = .5) +
   geom_point(data = osn %>% filter(x =="2"), aes(x = x), color = '#DC267F', size = 1.5, 
              alpha = .5) +
   geom_line(aes(x = x, group = id), color = 'grey5', alpha = .5) +
   
   geom_half_boxplot(
     data = osn %>% filter(x=="1"), aes(x=x, y = y), position = position_nudge(x = -.25), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#648FFF', alpha = .5) +
   
   geom_half_boxplot(
     data = osn %>% filter(x=="2"), aes(x=x, y = y), position = position_nudge(x = .15), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#DC267F', alpha = .5) #+
 
 # geom_half_violin(
 #    data = osn %>% filter(x=="1"),aes(x = x, y = y), position = position_nudge(x = -.37), 
 #    side = "l", fill = '#648FFF', alpha = .5, trim = FALSE) +
 # 
 # geom_half_violin(
 #    data = osn %>% filter(x=="2"),aes(x = x, y = y), position = position_nudge(x = .3), 
 #    side = "r", fill = "#DC267F", alpha = .5, trim = FALSE) 
 
 # Define additional settings
 osn_SSQ_converse <-  osn_SSQ_converse + scale_x_continuous(breaks=c(1,2), labels=c("1", "2")) + 
   xlab("Research visit") +
   theme_classic() + 
   theme(plot.title = element_text(hjust = 0.5), axis.text.y = element_blank(), axis.title.y = element_blank()) +
   coord_cartesian(ylim=c(y_lim_min, y_lim_max)) 
 
 # Save png of SSQ graphs 
 png = nullGrob()
 png("SSQ_vertical.png", width=6, height=10, units="in", res=500)
 multiplot(omni_SSQ_speech, omni_SSQ_spatial, omni_SSQ_qualities, omni_SSQ_converse, osn_SSQ_speech, osn_SSQ_spatial, osn_SSQ_qualities, osn_SSQ_converse, cols = 2)
 dev.off()
 
 ########################################################################################################
 
 
 
 ########################################################################################################
 ### PROMIS GRAPH
 y_lim_min = 30
 y_lim_max = 85
 
 omniT2_promis_kids = omniT2data$PROMIS_kids_v2
 omniT2_promis_adults = omniT2data$PROMIS_adults_v2
 osnT2_promis_kids = osnT2data$PROMIS_kids_v2
 osnT2_promis_adults = osnT2data$PROMIS_adults_v2
 n_omni=length(omniT2_promis_kids)
 n_osn=length(osnT2_promis_kids)
 omni <- data.frame(y = c(omniT2_promis_kids, omniT2_promis_adults),
                    x = rep(c(1,2), each=n_omni),
                    id = factor(rep(1:n_omni,2)))
 osn <- data.frame(y = c(osnT2_promis_kids, osnT2_promis_adults),
                   x = rep(c(1,2), each=n_osn),
                   id = factor(rep(1:n_osn,2)))
 
 # omni 
 omni_promis <- ggplot(data = omni, aes(y = y)) +
   
   geom_point(data = omni %>% filter(x =="1"), aes(x = x), color = '#FE6100', size = 1.5, 
              alpha = .5) +
   geom_point(data = omni %>% filter(x =="2"), aes(x = x), color = '#ffc29c', size = 1.5, 
              alpha = .5) +
   geom_line(aes(x = x, group = id), color = 'grey5', alpha = .5) +
   
   geom_half_boxplot(
     data = omni %>% filter(x=="1"), aes(x=x, y = y), position = position_nudge(x = -.25), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#FE6100', alpha = .5) +
   
   geom_half_boxplot(
     data = omni %>% filter(x=="2"), aes(x=x, y = y), position = position_nudge(x = .15), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#ffc29c', alpha = .5) #+
 
 # geom_half_violin(
 #    data = omni %>% filter(x=="1"),aes(x = x, y = y), position = position_nudge(x = -.37), 
 #    side = "l", fill = '#785EF0', alpha = .5, trim = FALSE) +
 # 
 # geom_half_violin(
 #    data = omni %>% filter(x=="2"),aes(x = x, y = y), position = position_nudge(x = .3), 
 #    side = "r", fill = "#FE6100", alpha = .5, trim = FALSE) 
 
 # Define additional settings
 omni_promis <-  omni_promis + scale_x_continuous(breaks=c(1,2), labels=c("Self-report", "Cargiver-report")) + 
   xlab("Research visit 2") + ylab("Score") +
   ggtitle('omni') +
   theme_classic() + 
   theme(plot.title = element_text(hjust = 0.5)) +
   coord_cartesian(ylim=c(y_lim_min, y_lim_max))

 # OSN   
 osn_promis <- ggplot(data = osn, aes(y = y)) +
   
   geom_point(data = osn %>% filter(x =="1"), aes(x = x), color = '#DC267F', size = 1.5, 
              alpha = .5) +
   geom_point(data = osn %>% filter(x =="2"), aes(x = x), color = '#f2adcf', size = 1.5, 
              alpha = .5) +
   geom_line(aes(x = x, group = id), color = 'grey5', alpha = .5) +
   
   geom_half_boxplot(
     data = osn %>% filter(x=="1"), aes(x=x, y = y), position = position_nudge(x = -.25), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#DC267F', alpha = .5) +
   
   geom_half_boxplot(
     data = osn %>% filter(x=="2"), aes(x=x, y = y), position = position_nudge(x = .15), 
     side = "r",outlier.shape = NA, center = TRUE, errorbar.draw = TRUE, width = .3, 
     fill = '#f2adcf', alpha = .5) #+
 
 # geom_half_violin(
 #    data = osn %>% filter(x=="1"),aes(x = x, y = y), position = position_nudge(x = -.37), 
 #    side = "l", fill = '#648FFF', alpha = .5, trim = FALSE) +
 # 
 # geom_half_violin(
 #    data = osn %>% filter(x=="2"),aes(x = x, y = y), position = position_nudge(x = .3), 
 #    side = "r", fill = "#DC267F", alpha = .5, trim = FALSE) 
 
 # Define additional settings
 osn_promis <-  osn_promis + scale_x_continuous(breaks=c(1,2), labels=c("Self-report", "Caregiver-report")) + 
   xlab("Research visit 2") + ylab("Score") +
   ggtitle('OSN') +
   theme_classic() + 
   theme(plot.title = element_text(hjust = 0.5), axis.text.y = element_blank(), axis.title.y = element_blank()) +
   coord_cartesian(ylim=c(y_lim_min, y_lim_max))
 
 # Save png of PROMIS graphs 
 png = nullGrob()
 png("promis.png", width=6, height=3, units="in", res=500)
 multiplot(omni_promis, osn_promis, cols = 2)
 dev.off()
 
 ########################################################################################################
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 ########################################################################################################
 ### DAILY HA USE GRAPH
 y_lim_min = 0
 y_lim_max = 19
 
 audioData=read.csv("~/Documents/projects/OtiS/figures_HJS/OtiS_phase2_demographics_auditoryInfo.csv")
 head(audioData)
 
 daily <- ggplot(audioData, aes(x=group, y=dailyHAuse_studyWeighted, color=group)) + 
    geom_boxplot()+
   #geom_violin(trim = TRUE)+
   #geom_dotplot(binaxis='y', stackdir='center', dotsize=1) +
   geom_jitter(size = 3) +
   scale_color_manual(values=c("#ffc29c", "#f2adcf")) +
   theme_classic() + 
   xlab("Group") + ylab("Daily HA use (hours)")
 
 # Save png of daily HA use graphs 
 png = nullGrob()
 png("dailyHAuse.png", width=3, height=3, units="in", res=500)
 multiplot(daily, cols = 1)
 dev.off()
 
 ############################################################################################################