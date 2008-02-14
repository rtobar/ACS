/*
 * ALMA - Atacama Large Millimiter Array (c) European Southern Observatory, 2007
 * 
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 * 
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this library; if not, write to the Free Software Foundation, Inc.,
 * 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 * 
 */
package alma.acsplugins.alarmsystem.gui.toolbar;

import java.awt.Component;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.Font;
import java.awt.FontMetrics;
import java.awt.Graphics2D;
import java.awt.Toolkit;
import java.awt.font.FontRenderContext;
import java.awt.geom.Rectangle2D;

import javax.swing.JComboBox;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.JPanel;
import javax.swing.ListCellRenderer;
import javax.swing.SwingConstants;

import alma.acsplugins.alarmsystem.gui.CellColor;

/**
 * The toolbar for the alarm panel
 * 
 * @author acaproni
 *
 */
public class Toolbar extends JPanel {
	
	/** 
	 * The rendered for the auto acknowledge combo box
	 * This renderer shows each level with it color as defined in CellColor
	 * 
	 * @author acaproni
	 *
	 */
	public class ComboBoxRenderer implements ListCellRenderer {
		
		/**
		 * Constructor
		 */
		public ComboBoxRenderer() {
			setOpaque(true);
		}

		/**
		 * @see ListCellRenderer
		 */
		public Component getListCellRendererComponent(JList list, Object value,
				int index, boolean isSelected, boolean cellHasFocus) {
			if (index==-1) {
				return ((ComboBoxValues)value).normalRenderer;
			}
			JLabel renderer=null;
			if (cellHasFocus) {
				return (ComboBoxValues.values()[index].focusRenderer);
			} else {
				return (ComboBoxValues.values()[index].normalRenderer);
			}
		}
		
	}
	
	/**
	 * The values  shown in the ComboBox.
	 * It contains the labels to use as renderer for each cell.
	 * One label is for the normal situation and the second one
	 * is used when the cell has focus (inverted colors)
	 * 
	 * @author acaproni
	 *
	 */
	public enum ComboBoxValues {
		NONE("None",CellColor.INACTIVE),
		PRIORITY3("Priority 3",CellColor.PRI_3),
		PRIORITY2("Priority 2",CellColor.PRI_2),
		PRIORITY1("Priority 1",CellColor.PRI_1);
		
		public final String title;
		public final JLabel normalRenderer;
		public final JLabel focusRenderer;
		
		// Width and height of the label
		// They are calculated from the dimension of the strings
		// to show
		private static int height=0;
		private static int width=0;
		
		/**
		 * Constructor
		 * 
		 * @param title
		 * @param color
		 */
		private ComboBoxValues(String tit, CellColor color) {
			title=tit;
			normalRenderer = new JLabel(tit);
			normalRenderer.setBackground(color.backg);
			normalRenderer.setForeground(color.foreg);
			normalRenderer.setHorizontalAlignment(SwingConstants.CENTER);
			normalRenderer.setVerticalAlignment(SwingConstants.CENTER);
			focusRenderer = new JLabel(tit);
			focusRenderer.setBackground(color.foreg);
			focusRenderer.setForeground(color.backg);
			focusRenderer.setHorizontalAlignment(SwingConstants.CENTER);
			focusRenderer.setVerticalAlignment(SwingConstants.CENTER);
		}
		
		/**
		 * Init the sizes of all the lables
		 */
		public static void initSizes() {
			for (ComboBoxValues val: ComboBoxValues.values()) {
				Font f = val.normalRenderer.getFont();
				FontMetrics fm = val.normalRenderer.getFontMetrics(f);
				int h = fm.getHeight()+5;
				int w = fm.charsWidth(val.title.toCharArray(), 0, val.title.length())+10;
				setHeight(h);
				setWidth(w);
			}
			
			Dimension d = new Dimension(ComboBoxValues.getWidth(),ComboBoxValues.getHeight());
			for (ComboBoxValues val: ComboBoxValues.values()) {
				val.normalRenderer.setPreferredSize(d);
				val.focusRenderer.setPreferredSize(d);
				val.normalRenderer.setMinimumSize(d);
				val.focusRenderer.setMinimumSize(d);
				val.normalRenderer.setMaximumSize(d);
				val.focusRenderer.setMaximumSize(d);
			}
			
			System.out.println(d);
		}
		
		/**
		 * Return the height of each label
		 * 
		 * @return The height of each lable
		 */
		public static int getHeight() {
			return height;
		}

		/**
		 * Return the width of each label
		 * 
		 * @return The width of each label
		 */
		public static int getWidth() {
			return width;
		}

		/**
		 * Set the height (static fields can't be
		 * called directly by the constructor)
		 * 
		 * @param height The new height
		 */
		private static void setHeight(int height) {
			if (height>ComboBoxValues.height) {
				ComboBoxValues.height = height;
			}
		}

		/**
		 * Set the width (static fields can't be
		 * called directly by the constructor)
		 * 
		 * @param width The new width
		 */
		private static void setWidth(int width) {
			if (width>ComboBoxValues.width) {
				ComboBoxValues.width = width;
			}
		}
	}
	
	private JComboBox autoAckLevelCB=new JComboBox(ComboBoxValues.values());

	private JLabel autoAckLbl = new JLabel("Auto ack: ");
	
	/**
	 * Constructor
	 */
	public Toolbar() {
		super();
		initialize();
	}
	
	/**
	 * Initialize the toolbar
	 */
	private void initialize() {
		FlowLayout layout = (FlowLayout)getLayout();
		layout.setAlignment(FlowLayout.LEFT);
		
		// Add the label and the combobox for auto ack
		Font fnt = autoAckLbl.getFont();
		Font newFont = fnt.deriveFont(fnt.getSize()*80/100);
		autoAckLbl.setFont(newFont);
		add(autoAckLbl);
		autoAckLevelCB.setFont(newFont);
		autoAckLevelCB.setEditable(false);
		// Set the colors of the renderers
		ComboBoxValues.initSizes();
		autoAckLevelCB.setRenderer(new ComboBoxRenderer());
		autoAckLevelCB.setSelectedIndex(ComboBoxValues.NONE.ordinal());
		autoAckLevelCB.setMaximumRowCount(ComboBoxValues.values().length);
		Dimension d = new Dimension(ComboBoxValues.getWidth(),ComboBoxValues.getHeight());
		//autoAckLevelCB.setPreferredSize(d);
		autoAckLevelCB.setMinimumSize(d);
		add(autoAckLevelCB);
	}
}
