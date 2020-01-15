from __future__ import division
from __future__ import print_function

import sys
from os import path
from argparse import ArgumentParser
import numpy as np

sys.path.append(path.dirname(path.dirname(path.dirname(path.dirname(path.abspath(__file__))))) + '/utils/')
sys.path.append(path.dirname(path.dirname(path.dirname(path.dirname(path.abspath(__file__))))) + '/CART/')


from algorithm_utils import StateData
from log_regr_lib import CartIter1_Loc2Glob_TD

def main():
    # Parse arguments
    parser = ArgumentParser()
    parser.add_argument('-cur_state_pkl', required=True,
                        help='Path to the pickle file holding the current state.')
    parser.add_argument('-prev_state_pkl', required=True,
                        help='Path to the pickle file holding the previous state.')
    parser.add_argument('-local_step_dbs', required=True,
                        help='Path to db holding local step results.')
    args, unknown = parser.parse_known_args()
    fname_cur_state = path.abspath(args.cur_state_pkl)
    fname_prev_state = path.abspath(args.prev_state_pkl)
    local_dbs = path.abspath(args.local_step_dbs)

    # Load global state
    global_state = StateData.load(fname_prev_state).data
    # Load local nodes output
    activePaths = CartIter1_Loc2Glob_TD.load(local_dbs).get_data()

    global_out = CartInitIter_Glob2Loc_TD(  globalTree = global_state['globalTree'],
                                            activePaths = activePaths )
    # Save global state
    global_state.save(fname=fname_cur_state)
    # Return the algorithm's output
    global_out.transfer()

if __name__ == '__main__':
    main()
