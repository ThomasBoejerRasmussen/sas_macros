/*******************************************************************************
SIMULATE DATA
*******************************************************************************/

/* Simulate source population with the following variables:
pop:          Sub-population the person belongs to
id:           Person ID
birth_date:   Date of birth.
fu_start:     Start of follow-up. Maximum of start of study, birth, immigration 
              etc.
fu_end:       End of follow-up. Minimum of end of study, death, censoring event, 
              emigration etc.
male:         Male (1 = yes)
*/

data dat1;
  call streaminit(1);
  format id 8. male 1. birth_date fu_start fu_end date9.;
  do id = 1 to 10**3;
    birth_date = "01JAN1960"d + floor(10**3 * rand("uniform", -1, 1));
    fu_start = birth_date + 2 * floor(10**3 * rand("uniform"));
    fu_end = fu_start + 2 * floor(10**3 * rand("uniform"));
    male = rand("bernoulli", 0.7);
    output;
  end;
run;

/*******************************************************************************
STANDARD EXAMPLE
*******************************************************************************/

/* If the birth_date, fu_start, and fu_end variables have
been named as here, the macro only needs an input and output dataset
name. The macro stratifies the risk-time for each person into age
and calendar year strata and then summarizes the risk-time. */
%risk_time(
  in_ds   = dat1,
  out_ds  = standard1
);

/*******************************************************************************
ADVANCED EXAMPLE
*******************************************************************************/

/* It could be that we are not interested in stratifying risk-time by age and 
calendar year, but by age and sex. We can do this by using the <stratify_by> 
parameter to specify that we do not want to stratify by calendar year (by
removing _year_ from the list) but at the same time that we want to stratify by 
gender (by adding the male variable to the list). Furthermore, we might want 
the risk-time to be given in days instead of years. We can control this using 
the <risk_time_unit> parameter. */
%risk_time(
  in_ds           = dat1,
  out_ds          = advanced1,
  stratify_by     = _age_ male,
  risk_time_unit  = days
);
