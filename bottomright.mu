use glyph;
use gl;
use glu;
use gltext;
use rvtypes;
use commands;

documentation: """
This is an rvio overlay script. Overlay scripts are Mu modules which
contain a function called main() with specific arguments which rvio
will supply. This script is not used by rv.

Draws the frame number on lower-right part the image. You specify
the opacity, greyscale value, and point size of the font as args. 

----
  rvio in.#.jpg -o out.mov -overlay taskburn Light .4 1.0 30.0
----

The above example will render a frame number in the bottom right
corner of the image with an opacity of 0.4 a greyscale value of 1
(white) and point size 30.0.

To change the font you must hack the frameburn.mu file to call
gltext.init() prior to setting the font size. The argument to
gltext.init() should be a path to a .ttf file. On the mac you need to
make sure this file is not "old" style -- 
it needs to have all of the font data in the data fork of the file.
""";

module: bottomright
{
    documentation: "See module documentation.";

    \: main (void; int w, int h, 
             int tx, int ty,
             int tw, int th,
             bool stereo,
             bool rightEye,
             int frame,
             [string] argv,
             [(string,string)] keyvals)
    {
        setupProjection(w, h);
        glEnable(GL_BLEND);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

        let _ : input_text : op : grey : size : _  = argv;

        gltext.size(int(size));

        let burnin_text   = input_text ,
            b      = gltext.bounds(burnin_text),
            sh     = b[1] + b[3],
            sw     = b[0] + b[2],
            x_margin = 80,
            y_margin = x_margin,
            x      = w - sw - x_margin,
            y      = y_margin,
            g      = float(grey),
            c      = Color(g, g, g, float(op));

        glColor(c);
        gltext.color(c);

        for_each (keyval; keyvals)
        {
            let (key, value) = keyval;

            if (key == "missing-image")
            {
                //
                //  Draw text red if a frame was missing
                //

                gltext.color(Color(1,0,0,float(op)));
            }
        }

        gltext.writeAt(x, y, burnin_text);
    }
}
