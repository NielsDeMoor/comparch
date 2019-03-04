    'virtual_instructions': {
        'inc': {
            'replace_with': 'addl',
            'operand_2': '01'
        },
        'dec': {
            'replace_with': 'subl',
            'operand_2': '01'
        },
        'clr': {
            'replace_with': 'movl',
            'operand_2': '00'
        },
        'jump': {
            'replace_with': 'jmp',
            'operand_2': None
        }
