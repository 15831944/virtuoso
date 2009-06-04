/*
 *  $Id$
 *
 *  This file is part of the OpenLink Software Virtuoso Open-Source (VOS)
 *  project.
 *
 *  Copyright (C) 1998-2008 OpenLink Software
 *
 *  This project is free software; you can redistribute it and/or modify it
 *  under the terms of the GNU General Public License as published by the
 *  Free Software Foundation; only version 2 of the License, dated June 1991.
 *
 *  This program is distributed in the hope that it will be useful, but
 *  WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 *  General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License along
 *  with this program; if not, write to the Free Software Foundation, Inc.,
 *  51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
 *
 */

package virtuoso.jena.driver;

import java.util.*;
import java.io.*;
import java.net.*;
import java.sql.*;

import virtuoso.sql.*;

import com.hp.hpl.jena.update.*;
import com.hp.hpl.jena.sparql.util.IndentedWriter;
import com.hp.hpl.jena.shared.*;

import virtuoso.jdbc3.VirtuosoConnectionPoolDataSource;

public class VirtuosoUpdateRequest 
{
    private List requests = new ArrayList() ;
    static final String charset = "UTF-8";

    private VirtuosoConnectionPoolDataSource pds = new VirtuosoConnectionPoolDataSource();

    String virt_graph = null;
    String virt_url  = null;
    String virt_user = null;
    String virt_pass = null;

    java.sql.Statement stmt = null;

    static {
	try {
		Class.forName("virtuoso.jdbc3.Driver");
	}
	catch (ClassNotFoundException e) {
            throw new JenaException("Can't load class 'virtuoso.jdbc3.Driver' :"+e);
	}
    }

    public VirtuosoUpdateRequest (VirtGraph graph)
    {
	virt_graph = graph.getGraphName ();
	virt_url  = graph.getGraphUrl ();
	virt_pass = graph.getGraphPassword ();
	virt_user = graph.getGraphUser ();
    }

    public VirtuosoUpdateRequest (String query, VirtGraph graph)
    {
        this(graph);
	requests.add((Object)query);
    }

    public void exec()
    { 
	try
	{
	    Connection connection;

	    if (virt_url.startsWith("jdbc:virtuoso://")) {

		Class.forName("virtuoso.jdbc3.Driver");
		connection = DriverManager.getConnection(virt_url, virt_user, virt_pass);
	    } else {
		pds.setServerName(virt_url);
		pds.setUser(virt_user);
		pds.setPassword(virt_pass);
		pds.setCharset(charset);
		javax.sql.PooledConnection pconn = pds.getPooledConnection();
		connection = pconn.getConnection();
	    }

	    stmt = connection.createStatement();

            for ( Iterator iter = requests.iterator() ; iter.hasNext(); )
            {
                String query = "sparql\n define output:format '_JAVA_'\n "+ (String)iter.next();
                stmt.execute(query);
            }

	    stmt.close();
	    stmt = null;
	    connection.close();
	}
	catch(Exception e)
	{
            throw new UpdateException("Convert results are FAILED.:", e);
	}

    }


    public void addUpdate(String update) { 
    	requests.add(update); 
    }

    public Iterator iterator() { 
    	return requests.iterator(); 
    }

    public String toString() {
      StringBuffer b = new StringBuffer();

      for ( Iterator iter = requests.iterator() ; iter.hasNext(); )
      {
         b.append((String)iter.next());
         b.append("\n");
      }
      return b.toString();
    }

    public void output(IndentedWriter out) {
        boolean first = true ;
        out.println() ;
        
        for ( Iterator iter = requests.iterator() ; iter.hasNext(); )
        {
            if ( ! first )
                out.println("    # ----------------") ;
            else
                first = false ;
            System.out.println((String)iter.next());
            out.ensureStartOfLine() ;
        }

    }

}
