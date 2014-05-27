#!/bin/sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

chmod 755 ${DIR}/ipa-build.sh
${DIR}/ipa-build.sh ${DIR} -w -s x6

#chmod 755 ${DIR}/ipa-publish.sh
#${DIR}/ipa-publish.sh ${DIR}