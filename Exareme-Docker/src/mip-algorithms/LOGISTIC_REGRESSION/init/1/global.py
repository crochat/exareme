from __future__ import division
from __future__ import print_function
from __future__ import unicode_literals

from os import path

import numpy as np
from argparse import ArgumentParser
from utils.algorithm_utils import StateData

from LOGISTIC_REGRESSION.log_regr_lib import LogRegrInit_Loc2Glob_TD, LogRegrIter_Glob2Loc_TD


def logregr_global_init(global_in):
    n_obs, n_cols, y_name, x_names = global_in.get_data()

    # Init vars
    ll = - 2 * n_obs * np.log(2)
    coeff = np.zeros(n_cols)
    iter_ = 0

    # Pack state and results
    global_state = StateData(n_obs=n_obs, n_cols=n_cols, ll=ll, coeff=coeff, iter_=iter_,
                             y_name=y_name, x_names=x_names)
    global_out = LogRegrIter_Glob2Loc_TD(coeff)

    return global_state, global_out


def main():
    # Parse arguments
    parser = ArgumentParser()
    parser.add_argument('-cur_state_pkl', required=True,
                        help='Path to the pickle file holding the current state.')
    parser.add_argument('-local_step_dbs', required=True,
                        help='Path to db holding local step results.')
    args, unknown = parser.parse_known_args()
    fname_cur_state = path.abspath(args.cur_state_pkl)
    local_dbs = path.abspath(args.local_step_dbs)

    # Load local nodes output
    local_out = LogRegrInit_Loc2Glob_TD.load(local_dbs)
    # Run algorithm global step
    global_state, global_out = logregr_global_init(global_in=local_out)
    # Save global state
    global_state.save(fname=fname_cur_state)
    # Return the algorithm's output
    global_out.transfer()


if __name__ == '__main__':
    main()
