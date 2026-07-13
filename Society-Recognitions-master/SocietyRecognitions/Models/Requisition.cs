using SocietyRecognitions.Models;
using System;
using System.Collections.Generic;

namespace Society_Requisitions.Models
{
    public class Requisition
    {
        public int r_id { get; set; }  // Primary key
        public int u_id { get; set; }   // Foreign key to User1
        public String society { get; set; }

        // Basic event information
        public string e_name { get; set; }
        public string e_venu { get; set; }
        public String e_budget { get; set; }

        // Event timing
        public String e_date { get; set; }
        public String e_time_from { get; set; }
        public String e_time_to { get; set; }

        // Event details
        public string e_type { get; set; }
        public string staff_req_main { get; set; }
        public string staff_req_other { get; set; }
        public string it_req_main { get; set; }
        public string it_req_other { get; set; }
        public string e_description { get; set; }

        // Approval fields
        public string student_affairs_action { get; set; }
        public string student_affairs_comments { get; set; }
        public string account_office_action { get; set; }
        public string account_office_comments { get; set; }

        // Navigation properties
        public virtual User user { get; set; }
    }
}