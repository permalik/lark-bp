#!/bin/zsh
kafkactl delete topic saga.prompt.raw
kafkactl delete topic prompt.raw
kafkactl delete topic prompt.clean
kafkactl delete topic inference.request
kafkactl delete topic inference.result
kafkactl delete topic response.delivery
kafkactl delete topic feedback.stub
