#!/bin/bash

main(){
  $(git rev-parse --abbrev-ref HEAD)
}

main 
