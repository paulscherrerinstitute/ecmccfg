"""Functional EL5021 counter, C-reset and latch model (no analog signal model)."""
import math


class EL5021:
    def __init__(self, counts_per_degree=819200, index=0.0, c_reset=True):
        if not math.isfinite(counts_per_degree) or counts_per_degree <= 0:
            raise ValueError('counts_per_degree must be positive and finite')
        self.scale = counts_per_degree
        self.index = index
        self.c_reset = c_reset
        self.offset = 0.0
        self.previous = None
        self.control = 0
        self.latch = 0
        self.valid = False

    def step(self, position, control=0, preset=0):
        if not math.isfinite(position):
            raise ValueError('position must be finite')
        control = int(control)
        crossing = self.previous is not None and (
            self.previous < self.index <= position or position <= self.index < self.previous)
        if not control & 1:
            self.valid = False
        if control & 4:
            self.offset = (int(preset) & 0xffffffff) - position * self.scale
        elif crossing:
            if control & 1 and not self.valid:
                self.latch = round(self.index * self.scale + self.offset) & 0xffffffff
                self.valid = True
            if self.c_reset:
                self.offset = -self.index * self.scale
        self.previous, self.control = position, control
        counter = round(position * self.scale + self.offset) & 0xffffffff
        return counter, int(self.valid) | (4 if control & 4 else 0), self.latch
