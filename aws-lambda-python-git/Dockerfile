FROM public.ecr.aws/lambda/python:3.13

LABEL python_version="3.13"
LABEL git_repo="https://github.com/ONSdigital/dp-concourse-tools"
LABEL git_commit="9f4e35f456bd1680e77b86901dab3e9d8f4509c4"
LABEL folder="aws-lambda-python-git"

RUN microdnf update && microdnf install git -y  
RUN pip install poetry