using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace PayLoad.Models
{
    public class Payload
    {
        public string country { get; set; }
        public string description { get; set; }
        public bool? drm { get; set; }
        public int? episodeCount { get; set; }
        public string genre { get; set; }
        public ImageType image { get; set; }
        public string language { get; set; }
        public Episode nextEpisode { get; set; }
        public string primaryColour { get; set; }
        public List<Season> seasons { get; set; }
        public string slug { get; set; }
        public string title { get; set; }
        public string tvChannel { get; set; }
    }
}