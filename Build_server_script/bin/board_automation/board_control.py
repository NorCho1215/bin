"""
Copyright (c) 2014, NVIDIA CORPORATION.  All Rights Reserved.

NVIDIA CORPORATION and its licensors retain all intellectual property
and proprietary rights in and to this software, related documentation
and any modifications thereto.  Any use, reproduction, disclosure or
distribution of this software and related documentation without an express
license agreement from NVIDIA CORPORATION is strictly prohibited

Interface to the board_automation library.
"""

DEBUG_BOARDS = ['pm342', 'pm292']


def set_command(name, args=None):
    out = {'name': name}
    if args:
        out['args'] = args
    return out

COMMANDS = {'reset': set_command('target_reset'),
            'recovery': set_command('target_recovery_mode'),
            'usb_on': set_command('enable_USB'),
            'usb_off': set_command('disable_USB'),
            'recovery_down': set_command('hold_button', 'FORCE_RECOVERY'),
            'recovery_up': set_command('release_button', 'FORCE_RECOVERY'),
            'onkey': set_command('push_button', 'ONKEY'),
            'power_on': set_command('target_power_on'),
            'power_off': set_command('target_power_off')}


def debug_board(target, variant=None, serial=None):
    """
    Return an instance of a debug board object
    """
    board_list = dict.fromkeys(DEBUG_BOARDS)
    for key in board_list.keys():
        try:
            module = __import__(key)
            board_class = getattr(module, key)
            board_list[key] = dict()
            board_list[key]['module'] = board_class
            board_list[key]['targets'] = board_class.supported_targets
        except ImportError:
            del board_list[key]
    if not board_list:
        return None
    for key in board_list:
        if target in board_list[key]['targets']:
            return board_list[key]['module'](target=target,
                                             variant=variant,
                                             serial=serial)
    return None


def board_command(board_object, command):
    """
    Send a command to the debug board
    """
    if command in COMMANDS:
        func_info = COMMANDS[command]
        # noinspection PyTypeChecker
        func = getattr(board_object, func_info['name'])
        if 'args' in func_info:
            func(*func_info['args'])
        else:
            func()
        return True
    return False
