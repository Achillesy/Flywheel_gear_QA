#!/bin/bash
echo 'Welcome to make autoQA bash'
echo 'Xuch.Liu, 2020'
rm ._* autoQA
rm ../Docker/autoQA
rm /flywheel/v0/autoQA
echo 'Pleas wait...'
mcc -m run_ACR_test.m fun_*.m -o autoQA
echo 'Done!'
rm mccExcludedFiles.log readme.txt requiredMCRProducts.txt run_autoQA.sh
