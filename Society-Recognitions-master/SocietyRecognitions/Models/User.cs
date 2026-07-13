using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SocietyRecognitions.Models
{
    public class User
    {
        public int id { get; set; }
        public String name { get; set; }
        public String email { get; set; }
        public String password { get; set; }
        public String role { get; set; }
        public String profilePictureUrl { get; set; }
        public String designation { get; set; }
    }
}