# Simulated interactive time series data

A simulated, well-behaved dataset of interactive time series data

## Usage

``` r
data(toy.ts.interaction.data)
```

## Format

A data frame with 50 rows and 23 variables:

- time:

  Indicator for time period

- x:

  Contemporaneous x

- l_1_x:

  First lag of x

- l_2_x:

  Second lag of x

- l_3_x:

  Third lag of x

- l_4_x:

  Fourth lag of x

- l_5_x:

  Fifth lag of x

- d_x:

  First difference of x

- l_1_d_x:

  First lag of first difference of x

- l_2_d_x:

  Second lag of first difference of x

- l_3_d_x:

  Third lag of first difference of x

- z:

  Contemporaneous z

- l_1_z:

  First lag of z

- l_2_z:

  Second lag of z

- l_3_z:

  Third lag of z

- l_4_z:

  Fourth lag of z

- l_5_z:

  Fifth lag of z

- y:

  Contemporaneous y

- l_1_y:

  First lag of y

- l_2_y:

  Second lag of y

- l_3_y:

  Third lag of y

- l_4_y:

  Fourth lag of y

- l_5_y:

  Fifth lag of y

- d_y:

  First difference of y

- l_1_d_y:

  First lag of first difference of y

- l_2_d_y:

  Second lag of first difference of y

- d_2_y:

  Second difference of y

- l_1_d_2_y:

  First lag of second difference of y

- x_z:

  Interaction of contemporaneous x and z

- x_l_1_z:

  Interaction of contemporaneous x and lagged z

- z_l_1_x:

  Interaction of lagged x and contemporaneous z

- l_1_x_l_1_z:

  Interaction of lagged x and lagged z
