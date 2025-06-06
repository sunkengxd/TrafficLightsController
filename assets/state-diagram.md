---
config:
  theme: redux
  look: classic
  layout: elk
title: Two-way semaphore state
---
stateDiagram
  direction TB
  state L1 {
    direction TB
    G1 --> Y1:30
    Y1 --> R1:10
    R1 --> RY1:20
    RY1 --> G1:10
    G1
    Y1
    R1
    RY1
  }
  state L2 {
    direction TB
    R2 --> RY2:30
    RY2 --> G2:10
    G2 --> Y2:20
    Y2 --> R2:10
    R2
    RY2
    G2
    Y2
  }
  [*] --> L1
  [*] --> L2
  L1 --> [*]
  L2 --> [*]
  L1:North South
  G1:Green
  Y1:Yellow
  R1:Red
  RY1:Red and Yellow
  L2:West East
  R2:Red
  RY2:Red and Yellow
  G2:Green
  Y2:Yellow
