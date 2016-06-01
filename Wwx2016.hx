import nme.display.Sprite;
import nme.display.DisplayObject;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.PixelSnapping;
import nme.geom.Point;
import nme.geom.Rectangle;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFieldAutoSize;
import nme.filters.GlowFilter;
import gm2d.ui.Layout;
import gm2d.reso.Resources;
import gm2d.svg.SvgRenderer;
import nme.Assets;

enum E { Val(a:Int,b:String); }

class Wwx2016 extends Talk
{
   public function new()
   {
      super();
      defaultTextColour = 0x000000;
      bulletBmp = Assets.getBitmapData("Bullet.png");
   }

   function imageBackground(inName:String)
   {
      var sw = stage.stageWidth;
      var sh = stage.stageHeight;

      var bmp = Assets.getBitmapData(inName);
      var bitmap = new Bitmap(bmp);

      var scale = Math.max( sw/bitmap.bitmapData.width, sh/bitmap.bitmapData.height );
      bitmap.scaleX = scale;
      bitmap.scaleY = scale;
      addChild(bitmap);
      bitmap.x = (sw - bitmap.width)*0.5;
      bitmap.y = (sh - bitmap.height)*0.5;
   }

   public function drawTitle(inText:Bool)
   {
      imageBackground("BBNew.jpg");

      var col = 0xffffff;
      var size = 60;

      var layout = createTitle("Hxcpp: What's new() ?", size, col);
      layout.add( createTextLayout(inText ? "Like Maid Marian, I've spent a lot of time under the Hood." : "", 20, 0xffffff) );
      setLayout(layout);
   }


   public function renderScreen0()
   {
      drawTitle(false);
   }

   public function renderScreen1()
   {
      drawTitle(true);
   }

   public function renderScreen10()
   {
      drawBg();
      var layout = createTitle('Highlights 2015/2016',36);
      bullet(layout,"Internal refactor");
      bullet(layout,"Many structures have been upgraded");
      bullet(layout,"Enum/Interfaces/Anon",2);
      bullet(layout,"GC Optimizations");
      bullet(layout,"micro/defragging/sizing",2);
      bullet(layout,"Hxcpp moves towards 'binary free'");
      bullet(layout,"compiler cache",2);
      setLayout(layout);
   }


   public function renderScreen30()
   {
      imageBackground("BBGuts.jpg");

      var col = 0xffffff;
      var size = 60;

      var layout = createTitle("In The Guts", size, col);
      setLayout(layout);
   }


   public function renderScreen40()
   {
      drawBg();
      var layout = createTitle("In the Guts of the Compiler ");

      bullet(layout,"Substantial rewrite of the ocaml code");
      bullet(layout,"Easier now I know where I'm going",2);
      bullet(layout,"Allows better reasoning about types",2);
      bullet(layout,"Generated code looks quite different",2);
      bullet(layout,"Better correspondence with haxe code",3);
      bullet(layout,"-D annotate_source for cpp/cppia",2);

      setLayout(layout);
   }



   public function showCode(which:Int)
   {
      var sw = stage.stageWidth;
      var sh = stage.stageHeight;
      var gfx = graphics;
      gfx.beginFill(0x000000);
      gfx.drawRect(0,0,sw,sh);


      var names = ["Hx", "Cpp", "Cppia"];
      var name = names[which];
      var layout = createTitleLayout( createTextLayout("Code:" + name,24, 0xffffff));

      var bmp = Assets.getBitmapData("Main" + name + ".png");
      var bitmap = new Bitmap(bmp,PixelSnapping.AUTO,true);
      addChild(bitmap);

      var scale = Math.min( stage.stageWidth/bmp.width, stage.stageHeight*0.8/bmp.height );
      bitmap.scaleX = bitmap.scaleY = scale*0.95;
      var bmpLayout = new DisplayLayout(bitmap);
    
      layout.add(bmpLayout);
      setLayout(layout);
   }
   public function renderScreen50() showCode(0);
   public function renderScreen51() showCode(1);
   public function renderScreen52() showCode(2);



   public function renderScreen59()
   {
      imageBackground("BBStructure.jpg");

      var col = 0xffffff;
      var size = 60;

      var layout = createTitle("\nStructures", size, col);
      setLayout(layout);
   }

   public function renderScreen60()
   {
      drawBg();
      var layout = createTitle("Structures");

      bullet(layout,'Redesigned to minimize allocations');
      bullet(layout,'Introduced cpp::Variant');
      bullet(layout,'Union of data, plus type tag',2);
      bullet(layout,'slightly slower get',3);
      bullet(layout,'much faster set (no boxing)',3);
      bullet(layout,'Used when accessing members dynamically');
      setLayout(layout);
   }



   public function renderSvg(title:String, asset:String, ?code:String)
   {
      drawBg();
      var layout = createTitle(title);
      if (code!=null)
         bullet(layout,code);

      var svg = new SvgRenderer(Resources.loadSvg(asset));
      var scale = Math.min( stage.stageWidth/svg.width, stage.stageHeight*0.8/svg.height );
      var shape = svg.createShape(new nme.geom.Matrix(scale,0,0,scale) );
      var svgLayout = new DisplayLayout(shape);
      svgLayout.setBestSize( scale*svg.width, scale*svg.height );
      addChild(shape);
      layout.add(svgLayout);

      setLayout(layout);
   }


   public function renderScreen70()
   {
      renderSvg( "enum E { Val(a:Int,b:String,c:Obj); }", "enum.svg");
      //renderSvg("Structure - Enum", "enum.svg", "enum E { Val(a:Int,b:String,c:Obj); }" );
   }

   public function renderScreen75()
   {
      var x = {a:1, b:'hi', c:this};
      renderSvg("{a:1, b:'hi', c:this}", "anon.svg");
   }


   public function renderScreen76()
   {
      renderSvg("@:fixed {a:1, b:'hi', c:this}", "anonfixed.svg");
   }

   public function renderScreen90()
   {
      drawBg();
      var layout = createTitle("Structure - Interfaces");

      bulletless(layout,'var i:Interface = someClassInstance; i.someFunc()');
      bullet(layout,'3.2');
      addCode(layout,[
         'var i = someClassInstance.createDelegate();',
         ' i.someFunc() return delegate.someFunc(); ',
      ]);


      bullet(layout,'3.3');
      addCode(layout,[
         'var i:Dynamic = someClassInstance;',
         ' i.toInterface("Interface").someFuncPtr(i); ',
      ]);

      setLayout(layout);
   }

   public function renderScreen95()
   {
      drawBg();
      var layout = createTitle(colour("Structure - Array<Dynamic>"));
      bullet(layout,colour('Array<Dynamic>  vs  Array<Any>'));
      bullet(layout,'Happens with templated classes, Json parsing');
      addCode(layout,[
         'var a:Array<Dynamic> = [1];',
         'a.push(1.2);',
         'var b:Array<Float> = cast a;',
         'b.push(1.3);',
         'trace(a);',
      ]);
      bullet(layout,'3.2  b is a copy of a');
      bullet(layout,'3.3  a has an internal pointer to b');
      bullet(layout,colour('Consider Array<{}> instead'));

      setLayout(layout);
   }


   public function renderScreen99()
   {
      imageBackground("BBGarbage.jpg");

      var col = 0xffffff;
      var size = 60;

      var layout = createTitle("\n\n\n\n\nGarbage Collection", size, col);
      setLayout(layout);

   }

   public function renderScreen100()
   {
      drawBg();
      var layout = createTitle("GC optimizations");
      bullet(layout,'Low-level (late 2015)');
      bullet(layout,'Inlined the "fast path" in "new"',3);
      bullet(layout,'Refactored conservative marking structures',3);
      bullet(layout,'High-level');
      bullet(layout,'HXCPP_GC_MOVING - for defragging',3);
      bullet(layout,'Tuned default memory sizes',3);
      bullet(layout,'HXCPP_GC_BIG_BLOCKS - for > 1Gig',3);
      setLayout(layout);
   }



   public function renderScreen109()
   {
      imageBackground("BBMoney.jpg");

      var col = 0xffffff;
      var size = 60;

      var layout = createTitle("\n\nShow Me The Money", size, col);
      setLayout(layout);
   }

   public function renderScreen110()
   {
      drawBg();
      var layout = createTitle("Benchmark");
      bullet(layout,'Mandelbrot test in tests/benchs/mandelbrot');
      bullet(layout,'Tests alloc performance, rather than compute');
      bullet(layout,'Holds a large array (RGB)',3);
      bullet(layout,'Creates lots of temps (Complex)',3);
      setLayout(layout);
   }


   public function renderGraph(items:Int, inCpp:Bool)
   {
      drawBg();
      var layout = createTitle("Benchmark");
      var graph = new Sprite();
      var scale = Math.min( stage.stageWidth/600, stage.stageHeight*0.75/400 );
      graph.scaleX = graph.scaleY = scale;

      var gfx = graph.graphics;
      gfx.lineStyle(1,0x000000);
      gfx.drawRect(0,0,600,400);

      var resultsCpp = [
         { name:"3.2.1 - Anon", time:113, col:0xff0000 },
         { name:"3.2.1 - Typed", time:7.94, col:0x00ff00 },
         { name:"3.2.1 - Anon + GC", time:64.85, col:0xff0000 },
         { name:"3.3   - Anon - Variant", time:18.61, col:0xff0000 },
         { name:"3.3   - Anon @:fixed", time:11.25, col:0xff0000 },
         { name:"3.3   - Typed", time:2.28, col:0x00ff00 },
         { name:"3.3   - Typed, 64 bit", time:1.92, col:0x00ff00 }
      ];


      var resultsOther = [
         { name:"Cpp", time:1.92, col:0x00ff00 },
         { name:"JS", time:1.1, col:0xff8000 },
         { name:"Java", time:0.76, col:0xffff00 },
         { name:"Cppia", time:46, col:0x00ff80 },
         { name:"Neko", time:95, col:0x0000ff }
      ];

      var results = inCpp ? resultsCpp : resultsOther;
      var max = inCpp ? 120 : (items<4 ? 10 : 110);

      var sy = 400/max;
      var w =  600 / 8;
      var fill = 0.9;

      for(i in 0...items)
      {
         var item = results[i];
         gfx.beginFill(item.col);
         var h = item.time*sy;
         gfx.drawRect( i*w, 400-h, w*fill, h );
         var text = createText( Std.string(item.time) + "s", 24/guiScale );
         text.x = i*w;
         text.y = 400-h-text.textHeight;
         graph.addChild(text);

         #if flash
         var textField = createText( item.name, 24/guiScale );
         textField.parent.removeChild(textField);
         var bmp = new BitmapData(Std.int(textField.width), Std.int(textField.height),true,0);
         bmp.draw(textField);
         var text = new Bitmap(bmp);
         #else
         var text = createText( item.name, 24/guiScale );
         #end
         var tw = text.width;

         text.rotation = -90;
         text.x = Std.int((i+0.1)*w);
         if (i==2 && inCpp || i==3 && !inCpp)
             text.y = 400;
         else
             text.y = Std.int(400-(400-tw) * 0.5);

         graph.addChild(text);
      }



      var graphLayout = new DisplayLayout(graph);
      graphLayout.setBestSize( scale*600, scale*400 );
      addChild(graph);
      layout.add(graphLayout);
      setLayout(layout);
   }

   public function renderScreen121() renderGraph(1,true);
   public function renderScreen122() renderGraph(2,true);
   public function renderScreen123() renderGraph(3,true);
   public function renderScreen124() renderGraph(4,true);
   public function renderScreen125() renderGraph(5,true);
   public function renderScreen126() renderGraph(6,true);
   public function renderScreen127() renderGraph(7,true);

   public function renderScreen131() renderGraph(1,false);
   public function renderScreen132() renderGraph(2,false);
   public function renderScreen133() renderGraph(3,false);
   public function renderScreen134() renderGraph(4,false);
   public function renderScreen135() renderGraph(5,false);



   public function renderScreen140()
   {
      imageBackground("BBLibraries.jpg");

      var col = 0xffffff;
      var size = 60;

      var layout = createTitle("Libraries", size, col);
      setLayout(layout);

   }
   public function renderScreen150()
   {
      drawBg();
      var layout = createTitle("Build-in libraries");
      bullet(layout,"Std, Regexp, ZLib, Sqlite, MySql",1,20);
      bullet(layout,"and now SSL",2,20);
      bullet(layout,"Are no longer linked as precompiled binaries or ndlls",1,20);
      bullet(layout,"Direct call, rather than via cffi",1,20);
      bullet(layout,"Versions are currently provided for legacy reasons",1,20);
      bullet(layout,"Built on your machine - no compiler mismatch",1,20);
      bullet(layout,"Little bit more compile time (but fear not...)",1,20);
      setLayout(layout);
   }


   public function renderScreen159()
   {
      imageBackground("BBCache.jpg");

      var col = 0xffffff;
      var size = 60;

      var layout = createTitle("The Cache", size, col);
      setLayout(layout);
   }

   public function renderScreen160()
   {
      drawBg();
      var layout = createTitle("HXCPP_COMPILE_CACHE");

      bullet(layout,"Set directory in - .hxcpp_config.xml is probably best");
      bullet(layout,"Set HXCPP_CACHE_SIZE 1024 (1Gig)");
      bullet(layout,'Manage with "haxelib run hxcpp cache list"');
      bullet(layout,'Shares obj files between projects',2);
      bullet(layout,'Hashes contents, not just dates',2);
      bullet(layout,'Tag compiler flags for individual files (eg, GC)',2);
      bullet(layout,'Little demo at end if we have time');
      setLayout(layout);
   }


   public function renderScreen169()
   {
      imageBackground("BBExtra.jpg");

      var col = 0xffffff;
      var size = 60;

      var layout = createTitle("What Else Is New?", size, col);
      setLayout(layout);
   }

   public function renderScreen170()
   {
      drawBg();
      var layout = createTitle("Misc");
      bullet(layout,'cpp.Stdlib - for malloc/free');
      bullet(layout,'cpp.NativeGc - stick data after obejcts');
      bullet(layout,'cpp.Finalizable - easier finalizers');
      bullet(layout,'Non-virtual functions where possible');
      bullet(layout,'hxScout');
      setLayout(layout);
   }

   public function renderScreen180()
   {
      drawBg();
      var layout = createTitle("@:nativeGen");
      bullet(layout,'Used for interfaces or classes with statics');
      bullet(layout,'Avoid non @:nativeGen in definitions',2);
      bullet(layout,'Interfaces use C++ multiple inheritance');
      bullet(layout,'Not hxcpp objects - no reflection etc',2);
      bullet(layout,'Do not need to #include&lt;hxcpp.h>');
      bullet(layout,' -> Do not need hxcpp it use',2);
      setLayout(layout);
   }

   public function renderScreen300()
   {
      drawBg();
      var layout = createTitle("Scorecard");

      layout.add( createTextLayout("Hit").setAlignment(Layout.AlignLeft) );
      bullet(layout,"Remove Dynamic where possible", 2);
      bullet(layout,"Fake Anon types via @:fixed",2);

      layout.add( createTextLayout("Glancing blow").setAlignment(Layout.AlignLeft) );
      bullet(layout,"Investigate Gc alternatives",2);
      bullet(layout,"Can do more",3);

      layout.add( createTextLayout("Miss").setAlignment(Layout.AlignLeft) );
      bullet(layout,"Cppia Jit (stretch goal)",2);

      setLayout(layout);
   }



   public function renderScreen310()
   {
      drawBg();
      var layout = createTitle("Future");
      bullet(layout,"Gc - generational/concurrent, reduce pause time");
      bullet(layout,"Refactor cppia ocaml code");
      bullet(layout,"Cppia Jit (stretch goal)");
      setLayout(layout);
   }

   public function renderScreen400()
   {
      drawBg();
      var layout = createTitle("Demo");

      bullet(layout,'HXCPP_COMPILE_CACHE');
      setLayout(layout);
   }




   public function addCode(layout, lines:Array<String>,size=20)
   {
      var box = createCodeBox( "<font size='" + (size*guiScale) + "'>" + colour(lines.join("\n")) + "</font>" );
      layout.add(box.layout);
   }

 
   function drawBg()
   {
      var sw = stage.stageWidth;
      var sh = stage.stageHeight;
      var gfx = graphics;
      gfx.beginFill(0xf0f0f0);
      gfx.drawRect(0,0,sw,sh);

      gfx.beginFill(0xffffff);
      gfx.lineStyle(1,0x3030ff);
      gfx.drawRect(10.5,20.5,sw-21,sh-41);
   }





}


