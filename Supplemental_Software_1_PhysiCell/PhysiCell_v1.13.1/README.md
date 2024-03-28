# Update project to use PhysiCell 1.13.1

This is an update to the original project. In particular, it:
* uses PhysiCell 1.13.1 (the original project used 1.7.1)
* just uses the `template` sample project executable (therefore custom.cpp is very different)
* uses PhysiCell Studio
* uses `config/body_cells.csv` for the initial conditions of the cells (rather than the original in setup_tissue())
* uses `config/body_rules.csv` to specify cell rules that prevent unrealistic overcrowding
* many of the original User Parameters are no longer used

We need to have a discussion about the original vs. this updated version, in terms of what is wanted in the model.

<img src="./screenshots/plot_svg_t0.png" width="50%">

<img src="./screenshots/plot_svg_1d12hr.png" width="70%">

<img src="./screenshots/populations.png" width="50%">

<img src="./screenshots/compare_rules.png" width="70%">Without rules vs. with

<img src="./screenshots/plot_pressure_1d12hr.png" width="50%">

<img src="./screenshots/basics.png" width="70%">

<img src="./screenshots/microenv.png" width="70%">
<img src="./screenshots/cycle.png" width="70%">
<img src="./screenshots/mechanics.png" width="70%">
<img src="./screenshots/motility.png" width="70%">
<img src="./screenshots/rules.png" width="70%">
<img src="./screenshots/user_params.png" width="70%">
<img src="./screenshots/rules.png" width="70%">
<img src="./screenshots/run.png" width="70%">







