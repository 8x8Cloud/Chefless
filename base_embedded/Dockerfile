FROM centos:latest

#just add true
#ADD true-asm /true
#CMD ["/true"]

# Add the Chef cookbooks and runtime info to a volume container
COPY berks-cookbooks /tmp/chef/cookbooks/
COPY zero.rb first-boot.json /tmp/chef/

# Create volumes
VOLUME /tmp/chef

ENTRYPOINT ["tail", "-f", "/dev/null"]