# Copyright (c) 2014, NVIDIA CORPORATION.  All Rights Reserved.
#
# NVIDIA CORPORATION and its licensors retain all intellectual property
# and proprietary rights in and to this software, related documentation
# and any modifications thereto.  Any use, reproduction, disclosure or
# distribution of this software and related documentation without an express
# license agreement from NVIDIA CORPORATION is strictly prohibited.

class pca954x:
    def __init__(self, i2c, addr):
        self.i2c = i2c
        self.addr = addr
        self.curr_branch = -1

    def switch_branch(self, branch):
        if self.curr_branch != branch:
            self.curr_branch = branch
            self.i2c.send_bytes(self.addr, [0, 2**branch])

    def send_bytes(self, branch, addr, data, issue_start=True,  issue_stop=True):
        self.switch_branch(branch)
        self.i2c.send_bytes(addr, data, issue_start, issue_stop)

    def read_bytes(self, branch, addr, length, issue_start=True, issue_stop=True):
        self.switch_branch(branch)
        return self.i2c.read_bytes(addr, length, issue_start, issue_stop)

class pca954x_branch:
    def __init__(self, pca954x, branch):
        self.pca954x = pca954x
        self.branch = branch

    def send_bytes(self, addr, data, issue_start=True, issue_stop=True):
        self.pca954x.send_bytes(self.branch, addr, data, issue_start, issue_stop)

    def read_bytes(self, addr, length, issue_start=True, issue_stop=True):
        return self.pca954x.read_bytes(self.branch, addr, length, issue_start, issue_stop)
