"""Parse TrafX outputs into machine readable tables

This script imports local copies of raw IR files
then parses raw files into clean csvs for analysis

It grabs the data table from the middle of a raw file
and also adds a first line representing the "START" time for the device,
and a last line, represeting the end "TIME" (or time of download in the field).
Start and end lines do not represent a count,
but do represent non-missing data, so give them a 0 count

Inputs:
  Requires a local directory with ir-raw/ (full of raw TrafX IR .txt files) and ir-raw-edits
  
Example:
  Generally this script is called from mae-ir-table, but it can also be run from command line::

    $ python -u parse_ir.py
"""

import os
import re
import datetime
import shutil
import glob
import argparse


def parse_ir_to_csv(ir_file, ir_dir, parsed_dir, dump_dir):
    if ir_file.lower().endswith('.txt'):
        nameparts = ir_file.split('_')
        siteid = nameparts[1]        
        table = open(os.path.join(ir_dir, ir_file), 'r')
        data = []
        countype = 20

        # init vars that should be found in lines, but won't be
        # if file has bad data:
        start = ''
        end = ''

        for line in table.readlines():
            # this expression returns lines with useful metadata/data
            dateline = re.search('.*[0-9][0-9]-[0-9][0-9]-[0-9][0-9].*', line)
            if 'PERIOD' in line:
                if '001' in line:
                    countype = 23
            if dateline:
                # Extract linetext
                #   respecting some data (from Alex W in 2019) w a carriage 
                #   return and slash ('\r\') at the end of many lines.
                #   yah, that's awesome.
                linetext = dateline.group(0).replace('\r\\', '').rstrip()
                # DOCK TIME and TIME lines are both the current time at download
                #   DOCK TIME only appears in files if Shuttle Mode was used
                # START is the launch time
                # if these are found, store the date-timestamp, 
                #   but continue without appending to data
                if '=DOCK TIME' in linetext:
                    continue
                if '=START' in linetext:
                    start = re.search('[0-9][0-9]-[0-9][0-9]-[0-9][0-9].*', linetext).group(0).rstrip()
                    continue
                if '=TIME' in linetext:
                    end = re.search('[0-9][0-9]-[0-9][0-9]-[0-9][0-9].*', linetext).group(0).rstrip()
                    continue
                
                # all the date-lines that are not special (above)
                # added to list
                data.append(linetext)
        
        # if metadata was found, write data to file
        if start != '' and end != '':
            outname = os.path.join(parsed_dir, ir_file.split('.')[0] + '.csv')
            outfile = open(outname, 'w')
            dumpname = os.path.join(dump_dir, ir_file.split('.')[0] + '.csv')
            dumpfile = open(dumpname, 'w')

            outfile.write('PlacementID,date,time,count,c1,c2,c3\n')

            # start and end lines do not represent a count,
            # but do represent non-missing data, so give them 0 count
            outfile.write(siteid + ',' + start + ',0,,,\n')
            for d in data:
                # check if line has abnormal data, deal with it later
                if len(''.join(d.split(','))) != countype:
                    dumpfile.write(siteid + ',' + d + '\n')
                outfile.write(siteid + ',' + d + '\n')
            outfile.write(siteid + ',' + end + ',0,,,\n')
            outfile.close()
            if len(data) > 0:
                print('Wrote ' + ir_file + ' with ' + str(len(data)) + ' records')
            else:
                print('NO DATA IN FILE? ' + ir_file)
    return(0)

