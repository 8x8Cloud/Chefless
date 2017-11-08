FROM centos:latest

#just add true
#ADD true-asm /true
#CMD ["/true"]

# Add the Chef cookbooks and runtime info to a volume container
COPY berks-cookbooks /tmp/chef/cookbooks/
COPY zero.rb first-boot.json /tmp/chef/

#Add our eght_app data sources to their respective folders
COPY roles/ /tmp/chef/roles
COPY data_bags/ /tmp/chef/data_bags
COPY environments/ /tmp/chef/environments
COPY nodes/ /tmp/chef/nodes

# Create volumes
VOLUME /tmp/chef

ENTRYPOINT ["tail", "-f", "/dev/null"]