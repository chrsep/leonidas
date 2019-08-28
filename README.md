[![Build Status](https://app.bitrise.io/app/729a799a3d70826f/status.svg?token=2-fwRnT3t4jZiXLQD7Qi2A)](https://app.bitrise.io/app/729a799a3d70826f)
[![codecov](https://codecov.io/gh/chrsep/leonidas/branch/develop/graph/badge.svg)](https://codecov.io/gh/chrsep/leonidas)
# leonidas

Exercise tracking app built on flutter. 

## Goal

Exercising is already a hard thing in itself, the need to track and calculate a bunch of stuff about our current workout plan adds even more complexity on top of it. This app aims to remove that complexity entirely, so that we can focus more on executing our workout instead of the planning and tracking part. 

## Roadmap
- [x] Automatically calculate weight progressions (currently modeled after Jim Wendler's 5/3/1 program)
- [x] Adapt weight calculation to available plates and barbell
- [x] Rest timer and exercise chronometer
- [x] Total exercise time.
- [x] Calculate plate configuration for every exercise
- [x] Automatically track what current and next workout session is based on our plan
- [x] Track 1RM for every exercise
- [ ] Automatically increase 1RM on every cycle (currently hardcoded)
- [ ] Edit 1RM of every exercise manually (currently hardcoded)
- [ ] Edit workout plan and progression (currently hardcoded)
- [ ] See complete history of every workout and exer    cise (time, weight, reps, etc)
- [ ] Complete exercise list to choose from (eg. call to ExRx's api)
- [ ] Record reps of every AMRAP set
- [ ] Track accessory exercises
- [ ] Support both imperial and metric unit (currently only do metric)
- [ ] Better data model to be able track any workout plan
- [ ] Export history to CSV
- [ ] Notifications for when to workout.
