========================================================================
         Intan RHD2000 *.rhd to Spike2 File Format Converter
========================================================================

To run:

Unzip the file.

Copy/move the .rhd file you want to convert to that directory

Open a DOS prompt, cd to the directory

Run: 
convert_to_Spike2 input_file.rhd output_file.smr

You can do all this without moving the file to the directory where the .exe
is; you'll just need to specify the full path of the file.

Note: Intan data must be saved in the "Traditional Intan File Format" for this
converter to work properly.  (See "Select File Format" dialog box in the RHD2000
interface GUI.)

Known bugs:  This converter is known to fail for very large files (e.g., 150-minute
recording in a single file).  It is recommended to break up recordings into shorter
durations in the "Select File Format" dialog box ("Start new file every N minutes").
