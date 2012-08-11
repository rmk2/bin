#!/bin/bash
ls | grep [0-9].JPG$ | awk '{print("mv "$1" "$1)}' | sed 's/.JPG//2' | /bin/sh
