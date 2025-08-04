#!/bin/zsh
kafkactl create topic saga.prompt.raw
kafkactl create topic prompt.raw
kafkactl create topic prompt.clean
kafkactl create topic inference.request
kafkactl create topic inference.result
kafkactl create topic response.delivery
kafkactl create topic feedback.stub
