#### NOT USED AUTOFS
# Note the autofs.service is not set to enable in systemd
# this is because tractor will first create its config file at the beginning of the tractor job
# then start autofs.service
#
# Make local mountpoint for autofs
#RUN mkdir /autofs
#RUN echo "/autofs /etc/auto.misc --timeout=0" >> /etc/auto.master
# todo: have tractor make this and remove it from here
#RUN echo "test -rw 172.31.7.236:/nfsshare" >> /etc/auto.misc
#COPY configure-nfs.sh /configure-nfs.sh
##RUN chmod 777 /configure-nfs.sh
#RUN chmod +x /configure-nfs.sh
####
