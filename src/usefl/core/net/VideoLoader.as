package usefl.core.net
{
    import flash.display.Sprite;
    import flash.events.NetStatusEvent;
    import flash.events.SecurityErrorEvent;
	import flash.events.StatusEvent;
    import flash.media.Video;
    import flash.net.NetConnection;
    import flash.net.NetStream;
    import flash.events.Event;
	import flash.utils.setTimeout;

    public class VideoLoader extends Sprite
	{
        private var videoURL:String = "video.flv";
        private var connection:NetConnection;
        private var stream:NetStream;
        private var video:Video = new Video();

        public function VideoLoader()
		{
            connection = new NetConnection();
            connection.addEventListener( NetStatusEvent.NET_STATUS, netStatusHandler );
            connection.addEventListener( SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler );
            connection.connect( null );
        }

        private function netStatusHandler( $e:NetStatusEvent ):void
		{
			trace( "$e.info.code : " + $e.info.code );
            switch ( $e.info.code )
			{
                case "NetConnection.Connect.Success":
                    connectStream();
					//setTimeout( connectStream, 200 );
                    break;
                case "NetStream.Play.StreamNotFound":
                    trace( "Stream not found: " + videoURL );
                    break;
				case "NetStream.Seek.Notify":
					trace( "버퍼?" );
					break;
				case "NetStream.Buffer.Full":
					trace( "버퍼끝" );
					break;
				case "NetStream.Buffer.Empty":
					break;
            }
        }

        private function securityErrorHandler( $e:SecurityErrorEvent ):void
		{
            trace( "securityErrorHandler: " + $e );
        }

        private function connectStream():void
		{
            addChild( video );
            stream = new NetStream( connection );
            stream.addEventListener( NetStatusEvent.NET_STATUS, netStatusHandler );
			stream.addEventListener( StatusEvent.STATUS, onTest );
            stream.client = new CustomClient();            
			stream.bufferTime = 0;
			stream.inBufferSeek = true;
			stream.bufferTimeMax = 0;
			video.width = 1366;
			video.height = 768;
			video.attachNetStream( stream );
            stream.play( videoURL );
			
			setTimeout( test, 2000 );
			this.addEventListener( Event.ENTER_FRAME, onEnter );
        }
		
		private function test2():void
		{
			stream.play();
			//
		}
		
		private function test():void
		{
			stream.seek( 180 );
			//
		}
		
		private function onEnter( $e:Event ):void
		{
			if ( stream != null )
			{
				//trace( stream.time );
				trace( stream.bufferLength, stream.bufferTime );
				//trace( stream.bytesLoaded + " / " + stream.bytesTotal + " / " + stream.inBufferSeek );
			}
		}
		
		private function onTest( $e:StatusEvent ):void 
		{
			trace( "onTest : " + $e.code );
		}
    }
}

class CustomClient 
{
	public function onPlayStatus( $info:Object ):void
	{
		trace( "onPlayStatus : " + $info.code );
	}
	
    public function onMetaData( info:Object ):void
	{
        trace("metadata: duration=" + info.duration + " width=" + info.width + " height=" + info.height + " framerate=" + info.framerate);
    }
    public function onCuePoint( info:Object ):void
	{
        trace("cuepoint: time=" + info.time + " name=" + info.name + " type=" + info.type);
    }
}