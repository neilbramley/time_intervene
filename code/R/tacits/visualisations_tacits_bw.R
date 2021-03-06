library(ggplot2)
library(tidyverse)
library(grid)
library(gridExtra)



#####################################################
#A general visualization on observing vs intervening
####################################################
rm(list=ls())

source('OU_generative.R')


df.cbn<-data.frame(
  variable = c('A','B','C'),
  time =
    event = intervention
)



#SIMULATE SOME CTCV
if(0) {
  betas <- array(c(-1,0,0,1,-1,0,0,0,-1), dim=c(3,3))
  vars  <- c(100,0,0)
  blah <- 0
  nruns <- 100000
  for (e in 1:nruns) {
    blah <- blah + OU_general(vars=c(100,0,0),betas = betas)
  }
  print(blah/nruns)
}

betas <- array(c(0,0,0,1,0,0,0,0,0), dim=c(3,3))
betas <- array(c(0,0,0,1,0,0,-2,0,0), dim=c(3,3))

#Chain
betas <- matrix(c(0.75,1.25,0,
                  0,0,-1.25,
                  0,0,0), ncol = 3, byrow = T)

betas

#No interventions
no_interventions<-matrix(NA, nrow=250, ncol=3)

#Large sine wave interventions
interventions<-matrix(NA, nrow=250, ncol=3)
interventions[51:100, 1]<-sin(seq(0,6*pi,length.out=50)) * 80
interventions[111:160, 3]<-sin(seq(0,6*pi,length.out=50)) * 80

#Static interventions
interventions<-matrix(NA, nrow=250, ncol=3)
interventions[31:70, 1]<--50
interventions[101:150, 2]<-50
interventions[191:230, 1]<-sin(seq(0,2*pi,length.out=40)) * -50+40
#Sine wave interventiosn
# interventions<-matrix(NA, nrow=200, ncol=3)
# interventions[101:140, 1]<-sin(seq(0,3*pi,length.out=40)) * 40 + 30
# interventions[151:190, 2]<-sin(seq(1,4*pi,length.out=40)) * 40 - 30



set.seed(101)
out.ni<-OU_general_run(vars = c(33,0,-33), betas = betas, interventions = no_interventions, ts_len = 250)
set.seed(101)
out<-OU_general_run(vars = c(33,0,-33), betas = betas, interventions = interventions, ts_len = 250)



df<-out.ni %>% data.frame %>% 
  setNames(., c("X[1]", "X[2]", "X[3]")) %>%
  gather(variable, value, "X[1]":"X[3]") %>%
  mutate(timestep = rep(1:nrow(out.ni), 3))

ggplot(df, aes(x=timestep, y=value, colour = variable, linetype = variable)) +
  geom_line() +
  labs(y='Value', x='Time', colour = '', linetype = '') +
  # scale_linetype_discrete(labels = function(variable) parse(text=variable), guide = F) +
  # scale_colour_discrete(labels = function(variable) parse(text=variable)) +
  scale_colour_grey() +
  coord_cartesian(ylim=c(-100,100)) +
  theme_bw() + 
  theme(panel.grid = element_blank(),axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        legend.position = 'bottom',
        legend.margin=margin(0,0,0,0),
        legend.box.margin=margin(-10,-10,0,-10)) +
  ggsave('../../../figures/tacits/subparts/ctcv_observe_bw.pdf', width = 5, height = 2)


df<-out %>% data.frame %>% 
  setNames(., c("X[1]", "X[2]", "X[3]")) %>%
  gather(variable, value, "X[1]":"X[3]") %>%
  mutate(timestep = rep(1:nrow(out), 3))

df$interventions<-c(rbind(c(NA,NA, NA),
                          interventions[1:nrow(interventions)-1,]))

ggplot(df, aes(x=timestep, y=value, linetype = variable, colour = variable)) +
  geom_line() +
  geom_line(aes(y=interventions, group=variable), colour = 'black',
            linetype = 2, size = 1) +
  # scale_linetype_discrete(labels = function(variable) parse(text=variable)) +
  # scale_colour_discrete(labels = function(variable) parse(text=variable)) +
  scale_colour_grey() +
  labs(y='Value', x='Time', linetype = 'Variable', colour = 'Variable') +
  coord_cartesian(ylim=c(-100,100)) +
  theme_bw() + 
  theme(panel.grid = element_blank(),axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        legend.position = 'bottom',
        legend.margin=margin(0,0,0,0),
        legend.box.margin=margin(-10,-10,0,-10)) +
  ggsave('../../../figures/tacits/subparts/ctcv_full_bw.pdf', width = 6, height = 2)





############################
#OU emergent behaviour
#############################

rm(list=ls())

source('OU_generative.R')


#OSCILIATOR INHIBITED
betas <- matrix(c(0,.5,
                  .5,0), ncol = 2, byrow = T)

betas

#No interventions
no_interventions<-matrix(NA, nrow=100, ncol=2)

set.seed(101)
out.ni<-OU_general_run(vars = c(100,-100), betas = betas, interventions = no_interventions, ts_len = 100)

df<-out.ni %>% data.frame %>% 
  setNames(., c("X[1]", "X[2]")) %>%
  gather(variable, value, "X[1]":"X[2]") %>%
  mutate(timestep = rep(1:nrow(out.ni), 2))

ggplot(df, aes(x=timestep, y=value, colour = variable, linetype = variable)) +
  geom_line() +
  labs(y='Value', x='Time', colour = '', linetype = '') +
  # scale_linetype_discrete(labels = function(variable) parse(text=variable), guide = F) +
  # scale_colour_discrete(labels = function(variable) parse(text=variable)) +
  scale_colour_grey() +
  coord_cartesian(ylim=c(-100,100)) +
  theme_bw() + 
  theme(panel.grid = element_blank(),axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        legend.position = 'bottom',
        legend.margin=margin(0,0,0,0),
        legend.box.margin=margin(-10,-10,0,-10)) +
  ggsave('../../../figures/tacits/subparts/ctcv_inhibit_bw.pdf', width = 2, height = 2)



#OSCILIATOR EXCITED
betas <- matrix(c(0,2,
                  2,0), ncol = 2, byrow = T)

betas

#No interventions
no_interventions<-matrix(NA, nrow=100, ncol=2)

set.seed(101)
out.ni<-OU_general_run(vars = c(100,-100), betas = betas, interventions = no_interventions, ts_len = 100, sigma =5)

df<-out.ni %>% data.frame %>% 
  setNames(., c("X[1]", "X[2]")) %>%
  gather(variable, value, "X[1]":"X[2]") %>%
  mutate(timestep = rep(1:nrow(out.ni), 2))

ggplot(df, aes(x=timestep, y=value, colour = variable, linetype = variable)) +
  geom_line() +
  labs(y='Value', x='Time', colour = '', linetype = '') +
  # scale_linetype_discrete(labels = function(variable) parse(text=variable), guide = F) +
  # scale_colour_discrete(labels = function(variable) parse(text=variable)) +
  scale_colour_grey() +
  coord_cartesian(ylim=c(-100,100)) +
  theme_bw() + 
  theme(panel.grid = element_blank(),axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        legend.position = 'bottom',
        legend.margin=margin(0,0,0,0),
        legend.box.margin=margin(-10,-10,0,-10)) +
  ggsave('../../../figures/tacits/subparts/ctcv_excite_bw.pdf', width = 2, height = 2)



#OSCILIATOR
betas <- matrix(c(0,2,
                  -2,0), ncol = 2, byrow = T)

betas

#No interventions
no_interventions<-matrix(NA, nrow=200, ncol=2)

set.seed(101)
out.ni<-OU_general_run(vars = c(5,-5), betas = betas, interventions = no_interventions, ts_len = 200, sigma = 5)

df<-out.ni %>% data.frame %>% 
  setNames(., c("X[1]", "X[2]")) %>%
  gather(variable, value, "X[1]":"X[2]") %>%
  mutate(timestep = rep(1:nrow(out.ni), 2))

ggplot(df, aes(x=timestep, y=value, colour = variable, linetype = variable)) +
  geom_line() +
  labs(y='Value', x='Time', colour = '', linetype = '') +
  # scale_linetype_discrete(labels = function(variable) parse(text=variable), guide = F) +
  # scale_colour_discrete(labels = function(variable) parse(text=variable)) +
  scale_colour_grey() +
  coord_cartesian(ylim=c(-100,100)) +
  theme_bw() + 
  theme(panel.grid = element_blank(),axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        legend.position = 'bottom',
        legend.margin=margin(0,0,0,0),
        legend.box.margin=margin(-10,-10,0,-10)) +
  ggsave('../../../figures/tacits/subparts/ctcv_oscillate_bw.pdf', width = 2, height = 2)
