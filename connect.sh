#!/bin/bash
# To be run on workstation
# Opens a connection to the specified ec2 instance via ssh. 
# Opens a reverse port forward port on the ec2 instance so that access to 802x in the
# ec2 instance connects back to workstation.

DEFAULT_EC2=ec2-13-228-146-49.ap-southeast-1.compute.amazonaws.com
DEFAULT_PORT=8022   #if port 8022 is used by another student, choose another port
KEYFILE=aws-jase-bkthong-key-pair.pem 
KEYFILE_LOCATION=~/.ssh/"${KEYFILE}"
echo
echo "Specify the ec2 instance public DNS"
read -p "[$DEFAULT_EC2] : " EC2
echo
read -p "Specify the port to use on ec2 to connect back to workstation ($DEFAULT_PORT) : " PORT
echo

#Use default values if nothing set
if [ "x$EC2" = "x" ] ; then
 EC2=${DEFAULT_EC2}
fi

if [ "x$PORT" = "x" ] ; then
 PORT=${DEFAULT_PORT}
fi

if [ \! -f "${KEYFILE_LOCATION}" ] ; then
  echo ERROR: Please ensure the ${KEYFILE} is copied to ~/.ssh/ and set its permission to be 600
  echo "ABORTING ..."
  echo
  exit 1
fi

#Change the file mode explicitly to avoid hassle of explaining ...
chmod 600 "${KEYFILE_LOCATION}"

#Connect and open reverse port-forwarding
ssh -i "${KEYFILE_LOCATION}" -R ${PORT}:localhost:22 ec2-user@${EC2}
