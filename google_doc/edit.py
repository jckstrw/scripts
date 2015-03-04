#!/usr/bin/python

import gspread

# Login with your Google account
gc = gspread.login('jmatthews@sovrn.com', 'ymzvisjvnzwddxua')

# Open a worksheet from spreadsheet with one shot
wks = gc.open("test_jim").sheet1

wks.update_acell('A24', "it's down there somewhere, let me take another look.")

# Fetch a cell range
cell_list = wks.range('A1:B7')
