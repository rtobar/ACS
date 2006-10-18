package com.cosylab.logging.settings;

import java.awt.BorderLayout;
import java.awt.ComponentOrientation;
import java.awt.Dimension;
import java.awt.Frame;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Insets;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.BorderFactory;
import javax.swing.Box;
import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JDialog;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JRootPane;

/**
 * A dialog to setup the preferences
 * 
 * @author acaproni
 *
 */
public class ExpertPrefsDlg extends JDialog implements ActionListener {
	
	/**
	 * A class containing the options for the time
	 */ 
	private class TimeOption {
		public String label;
		public int value;
		
		/**
		 * Constructor
		 * 
		 * @param lbl The label to show in the combo box
		 * @param val The number of minutes
		 */
		public TimeOption(String lbl, int val) {
			label=lbl;
			value=val;
		}
		
		public String toString() {
			return label;
		}
		
		/**
		 * @return The number of microsecond of the timeframe
		 *
		 */
		public long getTimeFrame() {
			return 1000*60*value;
		}
	}
	
	/**
	 * A class containing the options for the number of logs
	 */ 
	private class NumberOption {
		String label;
		int value;
		
		/**
		 * Constructor 
		 * 
		 * @param lbl The label to show
		 * @param val The number of logs
		 */
		public NumberOption(String lbl, int val) {
			label=lbl;
			value=val;
		}
		
		public String toString() {
			return label;
		}
	}
	
	// The ok and cancel buttons
	private JButton okBtn;
	private JButton cancelBtn;
	
	// Options for the time frame 
	private JComboBox timeCB;
	TimeOption [] timeOptions = {
		new TimeOption("Unlimited",0),
		new TimeOption("1h",60),
		new TimeOption("3h",180),
		new TimeOption("5h",300),
		new TimeOption("12h",720),
		new TimeOption("1d",1440)
	};
	
	// Options for the number of logs
	private JComboBox numCB;
	NumberOption[] numberOptions = {
			new NumberOption("Unlimited",0),
			new NumberOption("100K",100000),
			new NumberOption("200K",200000),
			new NumberOption("300K",300000),
			new NumberOption("400K",400000)
	};
	/**
	 * Constructor
	 * 
	 * @param owner The owner of the dialog
	 * @param title The title
	 * @param modal Modal type
	 */
	public ExpertPrefsDlg(Frame owner, String title, boolean modal) {
		super(owner, title, modal);
		this.setDefaultCloseOperation(DISPOSE_ON_CLOSE);
		initGUI();
		pack();
		setVisible(true);
	}
	
	/**
	 * @see java.awt.event.ActionListener
	 * @see java.awt.event.ActionEvent
	 */
	public void actionPerformed(ActionEvent e) {
		if (e.getSource()==okBtn) {
			setVisible(false);
			dispose();
		} else if (e.getSource()==cancelBtn) {
			setVisible(false);
			dispose();
		} else {
			System.err.println("Event not handled");
		}
	}
	
	/**
	 * Builds the GUI
	 *
	 */
	private void initGUI() {
		JRootPane mainPnl = this.getRootPane();
		mainPnl.setLayout(new BorderLayout());
		
		// The panel with the options
		JPanel optionsPanel = new JPanel();
		GridBagLayout prefsLayout = new GridBagLayout();
		GridBagConstraints c = new GridBagConstraints();
		optionsPanel.setLayout(prefsLayout);
		JLabel timeLbl = new JLabel("Time frame:");
		JLabel numLbl =  new JLabel("Max num. of logs:");
		c.gridx=0; c.gridy=0; c.anchor=GridBagConstraints.LAST_LINE_START; c.insets = new Insets(5,5,5,5);
		optionsPanel.add(timeLbl,c);
		c.gridx=0; c.gridy=1; c.anchor=GridBagConstraints.LAST_LINE_START; c.insets = new Insets(5,5,5,5);
		optionsPanel.add(numLbl,c);
		// The panel with the controls
		timeCB = new JComboBox(timeOptions);
		numCB  = new JComboBox(numberOptions);
		c.gridx=1; c.gridy=0; c.anchor=GridBagConstraints.LAST_LINE_START; c.insets = new Insets(5,5,5,5);
		optionsPanel.add(timeCB,c);
		c.gridx=1; c.gridy=1; c.anchor=GridBagConstraints.LAST_LINE_START; c.insets = new Insets(5,5,5,5);
		optionsPanel.add(numCB,c);
		// Add the label and prefs panel
		mainPnl.add(optionsPanel,BorderLayout.CENTER);
		
		// Add the OK, CANCEL buttons
		JPanel btnPnl = new JPanel();
		btnPnl.setComponentOrientation(ComponentOrientation.RIGHT_TO_LEFT);
		BoxLayout boxLayout = new BoxLayout(btnPnl,BoxLayout.LINE_AXIS);
		btnPnl.setLayout(boxLayout);
		btnPnl.setBorder(BorderFactory.createEmptyBorder(0, 10, 10, 10));
		okBtn = new JButton("Ok");
		okBtn.addActionListener(this);
		cancelBtn = new JButton("Cancel");
		cancelBtn.addActionListener(this);
		btnPnl.add(okBtn,BorderLayout.WEST);
		btnPnl.add(Box.createRigidArea(new Dimension(10, 0)));
		btnPnl.add(cancelBtn,BorderLayout.EAST);
		mainPnl.add(btnPnl,BorderLayout.SOUTH);
	}
}
